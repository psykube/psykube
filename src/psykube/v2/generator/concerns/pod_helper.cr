module Psykube::V2::Generator::Concerns::PodHelper
  alias ValidationError = Psykube::Generator::ValidationError
  include Psykube::Concerns::Volumes

  class InvalidHealthcheck < Exception; end

  # Templates and specs
  private def generate_pod_template
    Pyrite::Api::Core::V1::PodTemplateSpec.new(
      spec: generate_pod_spec,
      metadata: Pyrite::Apimachinery::Apis::Meta::V1::ObjectMeta.new(
        labels: {"app" => name}
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
      containers: generate_containers,
      init_containers: generate_init_containers,
    )
  end

  private def generate_job_template
    Pyrite::Api::Batch::V1beta1::JobTemplateSpec.new(
      spec: generate_job_spec
    )
  end

  private def generate_job_spec
    Pyrite::Api::Batch::V1::JobSpec.new(
      active_deadline_seconds: manifest.active_deadline,
      completions: manifest.completions,
      backoff_limit: manifest.backoff_limit,
      parallelism: manifest.parallelism,
      template: generate_pod_template
    )
  end

  # Containers
  private def generate_containers
    manifest.containers.map_with_index do |(container_name, container), index|
      Pyrite::Api::Core::V1::Container.new(
        name: container_name,
        image: @actor.build_contexts[index].image,
        resources: generate_container_resources(container),
        env: generate_container_env(container),
        volume_mounts: generate_container_volume_mounts(container.volumes),
        liveness_probe: generate_container_liveness_probe(container, container.healthcheck),
        readiness_probe: generate_container_readiness_probe(container, container.readycheck || container.healthcheck),
        ports: generate_container_ports(container.ports),
        command: generate_container_command(container.command),
        args: generate_container_args(container.args)
      )
    end
  end

  private def generate_init_containers
    manifest.init_containers.map_with_index do |(container_name, container), index|
      Pyrite::Api::Core::V1::Container.new(
        name: container_name,
        image: @actor.init_build_contexts[index].image,
        resources: generate_container_resources(container),
        env: generate_container_env(container),
        volume_mounts: generate_container_volume_mounts(container.volumes),
        liveness_probe: generate_container_liveness_probe(container, container.healthcheck),
        readiness_probe: generate_container_readiness_probe(container, container.readycheck || container.healthcheck),
        ports: generate_container_ports(container.ports),
        command: generate_container_command(container.command),
        args: generate_container_args(container.args)
      )
    end
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

  private def generate_volume(mount_path : String, volume : V1::Manifest::Volume)
    volume_name = name_from_mount_path(mount_path)
    volume.to_deployment_volume(name: name, volume_name: volume_name)
  end

  # Resources
  private def generate_container_resources(container)
    if (resources = container.resources)
      limits = resources.limits
      requests = resources.requests
      return unless limits || requests
      Pyrite::Api::Core::V1::ResourceRequirements.new(
        limits: limits && {"cpu" => limits.cpu, "memory" => limits.memory}.compact,
        requests: requests && {"cpu" => requests.cpu, "memory" => requests.memory}.compact
      )
    end
  end

  # Ports
  private def generate_container_ports(ports : Nil)
  end

  private def generate_container_ports(ports : PortMap)
    ports.map do |name, port|
      Pyrite::Api::Core::V1::ContainerPort.new(
        name: name,
        container_port: port
      )
    end
  end

  # Healthchecks
  private def generate_container_liveness_probe(container : Manifest::Shared::Container, null : Nil)
  end

  # TODO: Deprecate!
  private def generate_container_liveness_probe(container : Manifest::Shared::Container, enabled : Bool)
    return unless enabled && container.ports?
    Pyrite::Api::Core::V1::Probe.new(
      http_get: Pyrite::Api::Core::V1::HTTPGetAction.new(
        port: container.lookup_port "default"
      )
    )
  end

  private def generate_container_liveness_probe(container : Manifest::Shared::Container, healthcheck : V1::Manifest::Healthcheck | V1::Manifest::Readycheck)
    return unless healthcheck.http || healthcheck.tcp || healthcheck.exec
    raise InvalidHealthcheck.new("Cannot perform http check without specifying ports.") if !container.ports? && healthcheck.http
    raise InvalidHealthcheck.new("Cannot perform tcp check without specifying ports.") if !container.ports? && healthcheck.tcp
    Pyrite::Api::Core::V1::Probe.new(
      http_get: generate_container_probe_http_get(container, healthcheck.http),
      exec: generate_container_probe_exec(container, healthcheck.exec),
      tcp_socket: generate_container_probe_tcp_socket(container, healthcheck.tcp),
      initial_delay_seconds: healthcheck.initial_delay_seconds,
      timeout_seconds: healthcheck.timeout_seconds,
      period_seconds: healthcheck.period_seconds,
      success_threshold: healthcheck.success_threshold,
      failure_threshold: healthcheck.failure_threshold
    )
  end

  private def generate_container_readiness_probe(container : Manifest::Shared::Container, healthcheck : Nil)
  end

  private def generate_container_readiness_probe(container : Manifest::Shared::Container, healthcheck : Bool)
    generate_container_liveness_probe(container, healthcheck)
  end

  private def generate_container_readiness_probe(container : Manifest::Shared::Container, healthcheck : V1::Manifest::Healthcheck)
    if healthcheck.readiness
      generate_container_liveness_probe(container, healthcheck)
    end
  end

  private def generate_container_readiness_probe(container : Manifest::Shared::Container, readycheck : V1::Manifest::Readycheck)
    generate_container_liveness_probe(container, readycheck)
  end

  private def generate_container_probe_http_get(container : Manifest::Shared::Container, http : Nil)
  end

  private def generate_container_probe_http_get(container : Manifest::Shared::Container, enabled : Bool)
    Pyrite::Api::Core::V1::HTTPGetAction.new(
      port: container.lookup_port("default")
    ) if enabled
  end

  private def generate_container_probe_http_get(container : Manifest::Shared::Container, path : String)
    Pyrite::Api::Core::V1::HTTPGetAction.new(
      port: container.lookup_port("default"),
      path: path
    )
  end

  private def generate_container_probe_http_get(container : Manifest::Shared::Container, http_check : V1::Manifest::Healthcheck::Http)
    Pyrite::Api::Core::V1::HTTPGetAction.new(
      path: http_check.path,
      port: container.lookup_port(http_check.port).not_nil!,
      host: http_check.host,
      scheme: http_check.scheme,
      http_headers: http_check.headers.try(&.map { |k, v| Pyrite::Api::Core::V1::HTTPHeader.new(name: k, value: v) })
    )
  end

  private def generate_container_probe_tcp_socket(container : Manifest::Shared::Container, tcp : Nil)
  end

  private def generate_container_probe_tcp_socket(container : Manifest::Shared::Container, enabled : Bool)
    Pyrite::Api::Core::V1::TCPSocketAction.new(
      port: container.lookup_port "default"
    )
  end

  private def generate_container_probe_tcp_socket(container : Manifest::Shared::Container, port : String | Int32)
    Pyrite::Api::Core::V1::TCPSocketAction.new(
      port: container.lookup_port port
    )
  end

  private def generate_container_probe_tcp_socket(container : Manifest::Shared::Container, tcp : V1::Manifest::Healthcheck::Tcp)
    Pyrite::Api::Core::V1::TCPSocketAction.new(
      port: container.lookup_port tcp.port
    )
  end

  private def generate_container_probe_exec(container : Manifest::Shared::Container, exec : Nil)
  end

  private def generate_container_probe_exec(container : Manifest::Shared::Container, command : String)
    generate_container_probe_exec container, [command]
  end

  private def generate_container_probe_exec(container : Manifest::Shared::Container, exec : V1::Manifest::Healthcheck::Exec)
    generate_container_probe_exec container, exec.command
  end

  private def generate_container_probe_exec(container : Manifest::Shared::Container, command : Array(String))
    Pyrite::Api::Core::V1::ExecAction.new command: command
  end

  # Volume Mounts
  private def generate_container_volume_mounts(volumes : Nil)
  end

  private def generate_container_volume_mounts(volumes : VolumeMap)
    volumes.map do |mount_path, volume|
      volume_name = name_from_mount_path(mount_path)
      Pyrite::Api::Core::V1::VolumeMount.new(
        name: volume_name,
        mount_path: mount_path
      )
    end
  end

  # Environment
  private def generate_container_env(container)
    container.env.map do |key, value|
      expand_env(key, value)
    end
  end

  private def expand_env(key : String, value : V1::Manifest::Env)
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

  private def expand_env_config_map(key_ref : V1::Manifest::Env::KeyRef)
    Pyrite::Api::Core::V1::ConfigMapKeySelector.new(key: key_ref.key, name: key_ref.name)
  end

  private def expand_env_secret(key : String)
    raise ValidationError.new "Secret `#{key}` not defined in cluster: `#{cluster_name}`." unless cluster_secrets.has_key? key
    Pyrite::Api::Core::V1::SecretKeySelector.new(key: key, name: name)
  end

  private def expand_env_secret(key_ref : V1::Manifest::Env::KeyRef)
    Pyrite::Api::Core::V1::SecretKeySelector.new(key: key_ref.key, name: key_ref.name)
  end

  private def expand_env_field(field : String)
    Pyrite::Api::Core::V1::ObjectFieldSelector.new(
      field_path: field
    )
  end

  private def expand_env_field(field_ref : V1::Manifest::Env::FieldRef)
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

  private def expand_env_resource_field(field_ref : V1::Manifest::Env::ResourceFieldRef)
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
