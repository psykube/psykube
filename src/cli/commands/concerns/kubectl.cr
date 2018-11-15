{% if compare_versions(Crystal::VERSION, "0.27.0") < 0 %}
  require "tempfile"
  alias ExecStdio = Process::Stdio
{% else %}
  alias ExecStdio = Process::ExecStdio
{% end %}

module Psykube::CLI::Commands::Kubectl
  alias Flags = Hash(String, String | Bool)

  def self.bin
    @@bin ||= ENV["KUBECTL_BIN"]? || `which kubectl`.strip
  end

  def context
    actor.context
  end

  def set_images_from_current!
    spec = Pyrite::Api::Extensions::V1beta1::Deployment.from_json(kubectl_json(manifest: deployment, panic: false, error: false)).spec.not_nil!.template.not_nil!.spec.not_nil!
    actor.build_contexts.each do |build_context|
      if (container = spec.containers.find { |c| build_context.container_name == c.name })
        build_context.image, build_context.tag = container.image.to_s.split(':')
      end
      build_context
    end
    if (init_containers = spec.init_containers)
      actor.init_build_contexts.each do |build_context|
        if (container = init_containers.find { |c| build_context.container_name == c.name })
          build_context.image, build_context.tag = container.image.to_s.split(':')
        end
        build_context
      end
    end
  rescue JSON::ParseException
  end

  def kubectl_json(resource : String? = nil,
                   name : String? = nil,
                   flags : Flags = Flags.new,
                   manifest : Pyrite::Kubernetes::Resource | Pyrite::Api::Core::V1::List | Nil = nil,
                   export : Bool = true,
                   namespace : String? = namespace,
                   error : Bool | IO = true,
                   panic : Bool = true)
    tempfile = {% if compare_versions(Crystal::VERSION, "0.27.0") < 0 %}
        Tempfile.open("kubectl") do |io|
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
        end
      {% else %}
        File.tempfile do |io|
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
        end
      {% end %}
    return File.read(tempfile.path)
  end

  {% for m in %w(run exec new) %}
  def kubectl_{{m.id}}(command : String, args = [] of String, flags : Flags = Flags.new, manifest = nil, namespace : String? = namespace, input : Bool | ExecStdio = false, output : Bool | ExecStdio = true, error : Bool | ExecStdio = true{% if m == "run" %}, panic : Bool = true{% end %})
    File.exists?(Kubectl.bin) || self.panic("kubectl not found")
    flags = Flags.new.merge(flags)
    {% for io in %w(input output error) %}
    {{io.id}}_io = case {{io.id}}
      when true
        @{{io.id}}_io
      when IO
        {{io.id}}
      else
        Process::Redirect::Close
      end
    {% end %}

    # Add context and namespace
    command_args = [command]
    command_args << "--context=#{context}" if context
    command_args << "--namespace=#{NameCleaner.clean(namespace)}" if namespace
    command_args.concat args

    # Generate manifests and assign to --filename
    if manifest
      file = {% if compare_versions(Crystal::VERSION, "0.27.0") < 0 %}Tempfile.new{% else %}File.tempfile{% end %}(manifest.kind)
      file.print manifest.to_yaml
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

    puts (["DEBUG:", Kubectl.bin] + command_args).join(" ").colorize(:dark_gray) if ENV["PSYKUBE_DEBUG"]? == "true"
    Process.{{m.id}}(command: Kubectl.bin, args: command_args, input: input_io, output: output_io, error: error_io){% if m == "run" %}.tap do |process|
      self.panic "Process: `#{Kubectl.bin} #{command_args.join(" ")}` exited unexpectedly".colorize(:red) if panic && !process.success?
    end{% end %}
  end
  {% end %}

  def kubectl_get_pods(phase : String? = "Running")
    arguments = @arguments
    flags = Flags.new
    flags["--selector"] = deployment.try(&.spec.not_nil!.selector.try(&.match_labels.try(&.map(&.join("=")).join(",")))).to_s
    json = kubectl_json(resource: "pods", flags: flags, export: false)
    pods = Pyrite::Api::Core::V1::List.from_json(json).items.not_nil!.select do |pod|
      if pod.is_a?(Pyrite::Api::Core::V1::Pod)
        next pod unless phase
        (pod.status || Pyrite::Api::Core::V1::PodStatus.new).phase == phase
      end
    end

    # Exec into the pod
    if pods.any?(&.is_a? Pyrite::Api::Core::V1::Pod)
      pods
    else
      raise "There are no running pods, try running `psykube status`"
    end
  rescue e : Generator::ValidationError
    panic "Error: #{e.message}".colorize(:red)
  end

  def kubectl_create_namespace(namespace : String)
    namespace = NameCleaner.clean(namespace)
    begin
      Pyrite::Api::Core::V1::Namespace.from_json(kubectl_json(resource: "namespace", error: false, name: namespace, panic: false))
    rescue
      kubectl_run(command: "apply", manifest: Pyrite::Api::Core::V1::Namespace.new(
        metadata: Pyrite::Apimachinery::Apis::Meta::V1::ObjectMeta.new(
          name: namespace,
          labels: LABELS
        )
      ))
    end
  end

  def kubectl_delete_namespace(namespace : String, force = false)
    kubectl_run(command: "delete", error: false, panic: false, manifest: Pyrite::Api::Core::V1::Namespace.new(
      metadata: Pyrite::Apimachinery::Apis::Meta::V1::ObjectMeta.new(
        name: NameCleaner.clean(namespace)
      )
    ))
  end

  def kubectl_copy_namespace(from : String, to : String, resources : String, force : Bool = false, explicit : Bool = false)
    from = NameCleaner.clean(from)
    to = NameCleaner.clean(to)
    begin
      raise "forced" if force
      Pyrite::Api::Core::V1::Namespace.from_json(kubectl_json(resource: "namespace", name: to, panic: false))
      puts "Namespace exists, skipping copy...".colorize(:light_yellow)
    rescue
      puts "Copying Namespace: `#{from}` to `#{to}` (resources: #{resources.split(",").join(", ")})...".colorize(:cyan)
      # Gather the existing resources
      json = kubectl_json(resource: resources, namespace: from)
      list = Pyrite::Api::Core::V1::List.from_json json

      items = list.items.not_nil!.select do |resource|
        case resource.metadata.not_nil!.annotations.try(&.["psykube.io/allow-copy"]?)
        when "true"
          true
        when "false"
          false
        else
          !explicit
        end
      end

      items.each do |item|
        item.status = nil if item.responds_to?(:"status=")
        metadata = item.metadata.not_nil!
        metadata.namespace = to
        metadata.self_link = nil
        metadata.creation_timestamp = nil
        case item
        when Pyrite::Api::Core::V1::PersistentVolumeClaim
          item.spec.not_nil!.volume_name = nil
          if annotations = item.metadata.try(&.annotations)
            annotations.delete_if { |k, _| k.starts_with? "pv.kubernetes.io/" }
          end
        when Pyrite::Api::Core::V1::Service
          item.spec.not_nil!.cluster_ip = nil unless item.spec.not_nil!.cluster_ip == "None"
          item.spec.not_nil!.ports.not_nil!.each(&.node_port = nil)
        end
      end

      # Get or build the new namespace
      namespace = Pyrite::Api::Core::V1::Namespace.new(
        metadata: Pyrite::Apimachinery::Apis::Meta::V1::ObjectMeta.new(
          name: to,
          labels: LABELS
        )
      )
      items.unshift namespace
      items.each do |item|
        kubectl_run(command: "apply", manifest: item, flags: {"--force" => true}, namespace: to)
      end
    end
  end
end
