module Psykube::Commands::Kubectl
  alias Flags = Hash(String, String | Bool)
  BIN = ENV["KUBECTL_BIN"]? || `which kubectl`.strip

  def kubectl_json(resource : String? = nil,
                   name : String? = nil,
                   flags : Flags = Flags.new,
                   manifest : Kubernetes::Resource? = nil,
                   export : Bool = true,
                   namespace : String? = namespace,
                   error : Bool | IO = true,
                   panic : Bool = true)
    io = IO::Memory.new
    args = [] of String
    args << resource if resource
    args << name if name
    flags = Flags.new.merge(flags)
    flags.merge!({"--export" => export, "--output" => "json"})
    kubectl_run(
      command: "get",
      args: args,
      flags: flags,
      manifest: manifest,
      namespace: namespace,
      output: io,
      input: false,
      error: error,
      panic: panic
    )
    io.rewind
    io.gets_to_end
  end

  {% for m in %w(run exec new) %}
  def kubectl_{{m.id}}(command : String, args = [] of String, flags : Flags = Flags.new, manifest : Kubernetes::Resource? = nil, namespace : String? = namespace, input : Bool | IO = false, output : Bool | IO = true, error : Bool | IO = true{% if m == "run" %}, panic : Bool = true{% end %})
    flags = Flags.new.merge(flags)
    {% for io in %w(input output error) %}
    {{io.id}}_io = {{io.id}} == true ? @{{io.id}}_io : {{io.id}}{% end %}

    # Add context and namespace
    command_args = [command]
    command_args << "--context=#{context}" if context
    command_args << "--namespace=#{namespace}" if namespace
    command_args.concat args

    # Generate manifests and assign to --filename
    if manifest
      file = Tempfile.new(manifest.kind)
      file.print manifest.to_json
      file.flush
      flags["--filename"] = file.path
    end

    # Add flags as args
    flags.each do |k, v|
      case v
      when String
        command_args << "#{k}=#{v}"
      when Bool
        command_args << k if v
      end
    end

    puts ([BIN] + command_args).join(" ") if ENV["PSYKUBE_DEBUG"]? == "true"
    Process.{{m.id}}(command: BIN, args: command_args, input: input_io, output: output_io, error: error_io){% if m == "run" %}.tap do |process|
      self.panic "Process: `#{BIN} #{command_args.join(" ")}` exited unexpectedly".colorize(:red) if panic && !process.success?
    end{% end %}
  end
  {% end %}

  def kubectl_get_pods(phase : String? = "Running")
    arguments = @arguments
    flags = Flags.new
    flags["--selector"] = deployment_generator.result.spec.selector.match_labels.try(&.map(&.join("=")).join(",")).to_s
    json = kubectl_json(resource: "pods", flags: flags, export: false)
    pods = Kubernetes::List.from_json(json).items.select do |pod|
      if pod.is_a?(Kubernetes::Pod)
        next pod unless phase
        (pod.status || Kubernetes::Pod::Status.new).phase == phase
      end
    end

    # Exec into the pod
    if pods.any?(&.is_a? Kubernetes::Pod)
      pods
    else
      raise "There are no running pods, try running `psykube status`"
    end
  rescue e : Generator::ValidationError
    panic "Error: #{e.message}".colorize(:red)
  end

  def kubectl_copy_namespace(from : String, to : String, resources : String, force : Bool = false)
    begin
      raise "forced" if force
      Kubernetes::Namespace.from_json(kubectl_json(resource: "namespace", name: to, panic: false))
      puts "Namespace exists, skipping copy...".colorize(:light_yellow)
    rescue
      puts "Copying Namespace: `#{from}` to `#{to}` (resources: #{resources.split(",").join(", ")})...".colorize(:cyan)
      # Gather the existing resources
      json = kubectl_json(resource: resources, namespace: from)
      list = Kubernetes::List.from_json json

      # Get or build the new namespace
      namespace = Kubernetes::Namespace.new(to)
      list.unshift namespace

      # Clean the list
      list.clean!
      list.items.each do |item|
        kubectl_run(command: "apply", manifest: item, flags: {"--force" => true})
      end
    end
  end
end
