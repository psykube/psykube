module Psykube::Commands::Kubectl
  alias Flags = Hash(String, String | Bool)
  BIN = ENV["KUBECTL_BIN"]? || `which kubectl`.strip

  def kubectl_json(resource : String,
                   name : String? = nil,
                   flags : Flags = Flags.new,
                   export : Bool = true)
    io = IO::Memory.new
    args = [resource]
    args << name if name
    flags.merge!({"--export" => export, "--output" => "json"})
    kubectl_run(command: "get", args: args, flags: flags, output: io, input: false)
    io.rewind
    io.gets_to_end
  end

  {% for m in %w(run exec new) %}
  def kubectl_{{m.id}}(command : String, args = [] of String, flags : Flags = Flags.new, manifest : Kubernetes::Resource? = nil, input : Bool | IO = false, output : Bool | IO = true, error : Bool | IO = true)
    {% for io in %w(input output error) %}
    {{io.id}}_io = {{io.id}} == true ? @{{io.id}}_io : {{io.id}}{% end %}

    # Add context and namespace
    command_args = [command]
    command_args << "--context=#{context}" if context
    command_args << "--namespace=#{namespace}" if namespace
    command_args.concat args

    # Generate manifests and assign to --filename
    if manifest
      file = Tempfile.new("manifest")
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
    Process.{{m.id}}(command: BIN, args: command_args, input: input_io, output: output_io, error: error_io)
  end
  {% end %}

  def kubectl_get_pods(phase : String? = "Running")
    arguments = @arguments
    generator = Generator::Deployment.new(
      filename: flags.file,
      image: arguments.responds_to?(:cluster) ? arguments.cluster : nil
    )
    flags = Flags.new
    flags["--selector"] = generator.result.spec.selector.match_labels.try(&.map(&.join("=")).join(",")).to_s
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
  end
end
