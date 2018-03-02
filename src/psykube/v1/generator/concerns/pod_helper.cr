module Psykube::V1::Generator::Concerns::PodHelper
  alias ValidationError = Psykube::Generator::ValidationError
  include Psykube::Concerns::Volumes

  class InvalidHealthcheck < Exception; end

  # Templates and specs
  private def generate_pod_template
    Pyrite::Api::Core::V1::PodTemplateSpec.new(
      spec: generate_pod_spec,
      metadata: Pyrite::Apimachinery::Apis::Meta::V1::ObjectMeta.new(
        labels: {"app" => name},
      )
    )
  end

  private def generate_selector
    Pyrite::Apimachinery::Apis::Meta::V1::LabelSelector.new(
      match_labels: {
        "app" => name,
      }
    )
  end

  private def generate_pod_spec
    Pyrite::Api::Core::V1::PodSpec.new(
      restart_policy: manifest.restart_policy,
      volumes: generate_volumes,
      containers: [generate_container],
      init_containers: manifest.init_containers,
    )
  end

  # Containers
  private def generate_container
    Pyrite::Api::Core::V1::Container.new(
      name: name,
      image: @actor.build_contexts[0].image,
      resources: generate_container_resources,
      env: generate_container_env,
      volume_mounts: generate_container_volume_mounts(manifest.volumes),
      liveness_probe: generate_container_liveness_probe(manifest.healthcheck),
      readiness_probe: generate_container_readiness_probe(manifest.readycheck || manifest.healthcheck),
      ports: generate_container_ports(manifest.ports),
      command: generate_container_command(manifest.command),
      args: generate_container_args(manifest.args)
    )
  end

  # Volumes
  private def generate_volumes
    manifest_volumes.map do |mount_path, spec|
      generate_volume(mount_path, spec)
    end unless manifest_volumes.empty?
  end

  private def generate_volume(mount_path : String, size : String)
    volume_name = name_from_mount_path(mount_path)
    Pyrite::Api::Core::V1::Volume.new(
      name: volume_name,
      persistent_volume_claim: Pyrite::Api::Core::V1::PersistentVolumeClaimVolumeSource.new(
        claim_name: volume_name
      )
    )
  end

  private def generate_volume(mount_path : String, volume : Manifest::Volume)
    volume_name = name_from_mount_path(mount_path)
    volume.to_deployment_volume(name: name, volume_name: volume_name)
  end

  # Resources
  private def generate_container_resources
    if (resources = manifest.resources)
      limits = resources.limits
      requests = resources.requests
      return unless limits || requests
      Pyrite::Api::Core::V1::ResourceRequirements.new(
        limits: limits && {"cpu" => limits.cpu, "memory" => limits.memory}.compact,
        requests: requests && {"cpu" => requests.cpu, "memory" => requests.memory}.compact
      )
    end
  end

  # Ports\
  private def generate_container_ports(ports : Hash(String, Int32))
    return if ports.empty?
    ports.map do |name, port|
      Pyrite::Api::Core::V1::ContainerPort.new(
        name: name,
        container_port: port
      )
    end
  end

  # Healthchecks
  private def generate_container_liveness_probe(null : Nil)
  end

  # TODO: Deprecate!
  private def generate_container_liveness_probe(enabled : Bool)
    return unless enabled && manifest.ports?
    Pyrite::Api::Core::V1::Probe.new(
      http_get: Pyrite::Api::Core::V1::HTTPGetAction.new(
        port: lookup_port "default"
      )
    )
  end

  private def generate_container_liveness_probe(healthcheck : Manifest::Healthcheck | Manifest::Readycheck)
    return unless healthcheck.http || healthcheck.tcp || healthcheck.exec
    raise InvalidHealthcheck.new("Cannot perform http check without specifying ports.") if !manifest.ports? && healthcheck.http
    raise InvalidHealthcheck.new("Cannot perform tcp check without specifying ports.") if !manifest.ports? && healthcheck.tcp
    Pyrite::Api::Core::V1::Probe.new(
      http_get: generate_container_probe_http_get(healthcheck.http),
      exec: generate_container_probe_exec(healthcheck.exec),
      tcp_socket: generate_container_probe_tcp_socket(healthcheck.tcp),
      initial_delay_seconds: healthcheck.initial_delay_seconds,
      timeout_seconds: healthcheck.timeout_seconds,
      period_seconds: healthcheck.period_seconds,
      success_threshold: healthcheck.success_threshold,
      failure_threshold: healthcheck.failure_threshold
    )
  end

  private def generate_container_readiness_probe(healthcheck : Nil)
  end

  private def generate_container_readiness_probe(healthcheck : Bool)
    generate_container_liveness_probe(healthcheck)
  end

  private def generate_container_readiness_probe(healthcheck : Manifest::Healthcheck)
    if healthcheck.readiness
      generate_container_liveness_probe(healthcheck)
    end
  end

  private def generate_container_readiness_probe(readycheck : Manifest::Readycheck)
    generate_container_liveness_probe(readycheck)
  end

  private def generate_container_probe_http_get(http : Nil)
  end

  private def generate_container_probe_http_get(enabled : Bool)
    return unless manifest.ports?
    Pyrite::Api::Core::V1::HTTPGetAction.new(
      port: lookup_port("default")
    ) if enabled
  end

  private def generate_container_probe_http_get(path : String)
    return unless manifest.ports?
    case path
    when "true"
      generate_container_probe_http_get enabled: true if path == "true"
    when "false"
      generate_container_probe_http_get enabled: false if path == "false"
    else
      Pyrite::Api::Core::V1::HTTPGetAction.new(
        port: lookup_port("default"),
        path: path
      )
    end
  end

  private def generate_container_probe_http_get(http_check : Manifest::Healthcheck::Http)
    return unless manifest.ports?
    Pyrite::Api::Core::V1::HTTPGetAction.new(
      path: http_check.path,
      port: lookup_port(http_check.port).not_nil!,
      host: http_check.host,
      scheme: http_check.scheme,
      http_headers: http_check.headers.try(&.map { |k, v| Pyrite::Api::Core::V1::HTTPHeader.new(name: k, value: v) })
    )
  end

  private def generate_container_probe_tcp_socket(tcp : Nil)
  end

  private def generate_container_probe_tcp_socket(enabled : Bool)
    return unless manifest.ports?
    Pyrite::Api::Core::V1::TCPSocketAction.new(
      port: lookup_port "default"
    )
  end

  private def generate_container_probe_tcp_socket(port_name : String)
    return unless manifest.ports?
    case port_name
    when "true"
      return generate_container_probe_tcp_socket enabled: true
    when "false"
      return generate_container_probe_tcp_socket enabled: false
    else
      Pyrite::Api::Core::V1::TCPSocketAction.new(
        port: lookup_port port_name
      )
    end
  end

  private def generate_container_probe_tcp_socket(port : Int32)
    Pyrite::Api::Core::V1::TCPSocketAction.new(
      port: port
    )
  end

  private def generate_container_probe_tcp_socket(tcp : Manifest::Healthcheck::Tcp)
    Pyrite::Api::Core::V1::TCPSocketAction.new(
      port: lookup_port tcp.port
    )
  end

  private def generate_container_probe_exec(exec : Nil)
  end

  private def generate_container_probe_exec(command : String)
    generate_container_probe_exec [command]
  end

  private def generate_container_probe_exec(exec : Manifest::Healthcheck::Exec)
    generate_container_probe_exec exec.command
  end

  private def generate_container_probe_exec(command : Array(String))
    Pyrite::Api::Core::V1::ExecAction.new command: command
  end

  # Volume Mounts
  private def generate_container_volume_mounts(volumes : Nil)
  end

  private def generate_container_volume_mounts(volumes : Manifest::VolumeMap)
    volumes.map do |mount_path, volume|
      volume_name = name_from_mount_path(mount_path)
      Pyrite::Api::Core::V1::VolumeMount.new(
        name: volume_name,
        mount_path: mount_path
      )
    end
  end

  # Environment
  private def generate_container_env
    return if manifest.env.empty?
    manifest.env.map do |key, value|
      expand_env(key, value)
    end
  end

  private def expand_env(key : String, value : Manifest::Env)
    value_from = Pyrite::Api::Core::V1::EnvVarSource.new.tap do |value_from|
      case
      when config_map = value.config_map
        value_from.config_map_key_ref = expand_env_config_map(config_map)
      when secret = value.secret
        value_from.secret_key_ref = expand_env_secret(secret)
      when field = value.field
        value_from.field_ref = expand_env_field(field)
      when resource_field = value.resource_field
        value_from.resource_field_ref = expand_env_resource_field(resource_field)
      end
    end
    Pyrite::Api::Core::V1::EnvVar.new(name: key, value_from: value_from)
  end

  private def expand_env(key : String, value : String)
    Pyrite::Api::Core::V1::EnvVar.new(name: key, value: value)
  end

  private def expand_env_config_map(key : String)
    raise ValidationError.new "ConfigMap `#{key}` not defined in cluster: `#{cluster_name}`." unless cluster_config_map.has_key? key
    Pyrite::Api::Core::V1::ConfigMapKeySelector.new(key: key, name: name)
  end

  private def expand_env_config_map(key_ref : Manifest::Env::KeyRef)
    Pyrite::Api::Core::V1::ConfigMapKeySelector.new(key: key_ref.key, name: key_ref.name)
  end

  private def expand_env_secret(key : String)
    raise ValidationError.new "Secret `#{key}` not defined in cluster: `#{cluster_name}`." unless cluster_secrets.has_key? key
    Pyrite::Api::Core::V1::SecretKeySelector.new(key: key, name: name)
  end

  private def expand_env_secret(key_ref : Manifest::Env::KeyRef)
    Pyrite::Api::Core::V1::SecretKeySelector.new(key: key_ref.key, name: key_ref.name)
  end

  private def expand_env_field(field : String)
    Pyrite::Api::Core::V1::ObjectFieldSelector.new(
      field_path: field
    )
  end

  private def expand_env_field(field_ref : Manifest::Env::FieldRef)
    Pyrite::Api::Core::V1::ObjectFieldSelector.new(
      field_path: field_ref.path,
      api_version: field_ref.api_version
    )
  end

  private def expand_env_resource_field(resource_field : String)
    Pyrite::Api::Core::V1::ResourceFieldSelector.new(
      resource: resource_field
    )
  end

  private def expand_env_resource_field(field_ref : Manifest::Env::ResourceFieldRef)
    Pyrite::Api::Core::V1::ResourceFieldSelector.new(
      resource: field_ref.resource,
      container_name: field_ref.container,
      divisor: field_ref.divisor
    )
  end

  private def generate_container_command(string : String)
    generate_container_command [string]
  end

  private def generate_container_command(strings : Array(String))
    strings
  end

  private def generate_container_command(strings : Nil) : Nil
  end

  private def generate_container_args(strings : Array(String))
    strings
  end

  private def generate_container_args(strings : Nil) : Nil
  end
end
