module Psykube::Generator::Concerns::PodHelper
  alias ValidationError = Psykube::Generator::ValidationError
  include Psykube::Concerns::Volumes

  class InvalidHealthcheck < Error; end

  # Templates and specs
  private def generate_pod_template(role = @role)
    Pyrite::Api::Core::V1::PodTemplateSpec.new(
      spec: generate_pod_spec,
      metadata: Pyrite::Apimachinery::Apis::Meta::V1::ObjectMeta.new(
        labels: {
          "app"             => name,
          "psykube.io/type" => role,
        },
        annotations: stringify_hash_values(manifest.pod_annotations)
      )
    )
  end

  private def generate_selector(role = @role)
    Pyrite::Apimachinery::Apis::Meta::V1::LabelSelector.new(
      match_labels: {
        "app"             => name,
        "psykube.io/type" => role,
      }
    )
  end

  private def generate_pod_spec
    Pyrite::Api::Core::V1::PodSpec.new(
      restart_policy: manifest.restart_policy,
      volumes: generate_volumes(combined_volumes),
      containers: generate_containers,
      init_containers: generate_init_containers(manifest.init_containers),
      security_context: generate_security_context,
      image_pull_secrets: generate_image_pull_secrets(manifest.image_pull_secrets),
      service_account_name: generate_service_account_name(manifest.service_account),
      host_pid: manifest.host_pid,
      host_network: manifest.host_network,
      dns_policy: manifest.dns_policy,
      termination_grace_period_seconds: manifest.termination_grace_period,
      tolerations: manifest.tolerations,
      node_selector: stringify_hash_values(manifest.node_selector.try(&.merge(cluster.node_selector || StringableMap.new)) || cluster.node_selector)
    )
  end

  private def generate_service_account_name(name : String)
    name
  end

  private def generate_service_account_name(service_account : Manifest::Shared::ServiceAccount)
    self.name
  end

  private def generate_service_account_name(service_account : Nil)
    self.name if manifest.roles || manifest.cluster_roles
  end

  private def generate_service_account_name(service_account : Bool)
    self.name if service_account || manifest.roles || manifest.cluster_roles
  end

  private def generate_job_template(manifest = self.manifest, role = @role)
    Pyrite::Api::Batch::V1beta1::JobTemplateSpec.new(
      spec: generate_job_spec(manifest, role)
    )
  end

  private def generate_job_spec(manifest = self.manifest, role = @role)
    Pyrite::Api::Batch::V1::JobSpec.new(
      active_deadline_seconds: manifest.active_deadline,
      completions: manifest.completions,
      backoff_limit: manifest.backoff_limit,
      parallelism: manifest.parallelism,
      template: generate_pod_template(role).tap { |t| t.spec.not_nil!.restart_policy = manifest.restart_policy || "OnFailure" }
    )
  end

  private def generate_job_spec(_nil : Nil, role = @role)
    Pyrite::Api::Batch::V1::JobSpec.new(
      template: generate_pod_template(role).tap { |t| t.spec.not_nil!.restart_policy = "OnFailure" }
    )
  end

  # Containers
  private def generate_container(container_name, container, image)
    Pyrite::Api::Core::V1::Container.new(
      name: container_name,
      image: image,
      image_pull_policy: container.image_pull_policy,
      resources: generate_container_resources(container),
      working_dir: container.working_dir,
      env: generate_container_env(container),
      volume_mounts: generate_container_volume_mounts(container.volume_mounts || container.volumes),
      liveness_probe: generate_container_liveness_probe(container, container.healthcheck),
      readiness_probe: generate_container_readiness_probe(container, container.readycheck || container.healthcheck),
      ports: generate_container_ports(container.ports),
      command: generate_exec_array(container.command),
      args: generate_exec_array(container.args),
      security_context: generate_security_context(container.security_context),
      lifecycle: generate_container_lifecycle(container, container.lifecycle)
    )
  end

  private def generate_containers
    manifest.containers.map_with_index do |(container_name, container), index|
      generate_container(container_name, container, @actor.build_contexts[index].image)
    end
  end

  private def generate_init_container(container_name, init_container : Manifest::Shared::Container, index)
    generate_container(container_name, init_container, @actor.init_build_contexts[index].image)
  end

  private def generate_init_container(container_name, command : Array(String) | String, _index)
    generate_container(container_name, manifest.containers.values.first, @actor.build_contexts.first.image).tap do |container|
      container.liveness_probe = nil
      container.readiness_probe = nil
      container.ports = nil
      container.args = nil
      container.resources = nil
      container.command = generate_exec_array(command)
    end
  end

  private def generate_init_containers(init_containers : Hash)
    return if manifest.init_containers.empty?
    manifest.init_containers.map_with_index do |(container_name, container), index|
      generate_init_container(container_name, container, index)
    end
  end

  # Volumes
  private def generate_volumes(volumes : VolumeMap)
    volumes.map do |name, spec|
      volume_name = [self.name, name].join('-')
      generate_volume(volume_name, spec)
    end unless volumes.empty?
  end

  private def generate_volume(volume_name : String, size : String)
    Pyrite::Api::Core::V1::Volume.new(
      name: volume_name,
      persistent_volume_claim: Pyrite::Api::Core::V1::PersistentVolumeClaimVolumeSource.new(
        claim_name: volume_name
      )
    )
  end

  private def generate_volume(volume_name : String, size : Nil)
    Pyrite::Api::Core::V1::Volume.new(
      name: volume_name,
      empty_dir: Pyrite::Api::Core::V1::EmptyDirVolumeSource.new
    )
  end

  private def generate_volume(volume_name : String, volume_alias : Manifest::Volume::Alias)
    Pyrite::Api::Core::V1::Volume.new(
      name: volume_name,
      secret: alias_to_secret(volume_alias.secret),
      config_map: alias_to_config_map(volume_alias.config_map)
    )
  end

  private def alias_to_secret(_nil : Nil) : Nil
  end

  private def alias_to_secret(item : String)
    alias_to_secret([item])
  end

  private def alias_to_secret(items : Array(String))
    key_paths = items.map do |item|
      raise Error.new("Unknown secret alias: #{item}") unless combined_secrets[item]? || secrets_disabled?
      Pyrite::Api::Core::V1::KeyToPath.new(key: item, path: item)
    end
    Pyrite::Api::Core::V1::SecretVolumeSource.new(
      secret_name: name,
      items: key_paths
    )
  end

  private def alias_to_config_map(_nil : Nil) : Nil
  end

  private def alias_to_config_map(item : String)
    alias_to_config_map([item])
  end

  private def alias_to_config_map(items : Array(String))
    key_paths = items.map do |item|
      raise Error.new("Unknown config_map alias: #{item}") unless manifest.config_map[item]?
      Pyrite::Api::Core::V1::KeyToPath.new(key: item, path: item)
    end
    Pyrite::Api::Core::V1::ConfigMapVolumeSource.new(
      name: name,
      items: key_paths
    )
  end

  private def generate_volume(volume_name : String, claim : Manifest::Volume::Claim)
    Pyrite::Api::Core::V1::Volume.new(
      name: volume_name,
      persistent_volume_claim: Pyrite::Api::Core::V1::PersistentVolumeClaimVolumeSource.new(
        claim_name: volume_name,
        read_only: claim.read_only
      )
    )
  end

  private def generate_volume(volume_name : String, spec : Manifest::Volume::Spec)
    Pyrite::Api::Core::V1::Volume.new(
      name: volume_name,
      aws_elastic_block_store: spec.aws_elastic_block_store,
      azure_disk: spec.azure_disk,
      azure_file: spec.azure_file,
      cephfs: spec.cephfs,
      cinder: spec.cinder,
      config_map: spec.config_map,
      downward_api: spec.downward_api,
      empty_dir: spec.empty_dir,
      fc: spec.fc,
      flex_volume: spec.flex_volume,
      flocker: spec.flocker,
      gce_persistent_disk: spec.gce_persistent_disk,
      git_repo: spec.git_repo,
      glusterfs: spec.glusterfs,
      host_path: spec.host_path,
      iscsi: spec.iscsi,
      nfs: spec.nfs,
      persistent_volume_claim: spec.persistent_volume_claim,
      photon_persistent_disk: spec.photon_persistent_disk,
      portworx_volume: spec.portworx_volume,
      projected: spec.projected,
      quobyte: spec.quobyte,
      rbd: spec.rbd,
      scale_io: spec.scale_io,
      secret: spec.secret,
      storageos: spec.storageos,
      vsphere_volume: spec.vsphere_volume
    )
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
  private def generate_container_ports(ports : PortMap)
    return if ports.empty?
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
        port: container.lookup_port!
      )
    )
  end

  private def generate_container_liveness_probe(container : Manifest::Shared::Container, healthcheck : Manifest::Healthcheck | Manifest::Readycheck)
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

  private def generate_container_readiness_probe(container : Manifest::Shared::Container, healthcheck : Manifest::Healthcheck)
    if healthcheck.readiness
      generate_container_liveness_probe(container, healthcheck)
    end
  end

  private def generate_container_readiness_probe(container : Manifest::Shared::Container, readycheck : Manifest::Readycheck)
    generate_container_liveness_probe(container, readycheck)
  end

  private def generate_container_probe_http_get(container : Manifest::Shared::Container, http : Nil)
  end

  private def generate_container_probe_http_get(container : Manifest::Shared::Container, enabled : Bool)
    Pyrite::Api::Core::V1::HTTPGetAction.new(
      port: container.lookup_port!
    ) if enabled
  end

  private def generate_container_probe_http_get(container : Manifest::Shared::Container, path : String)
    Pyrite::Api::Core::V1::HTTPGetAction.new(
      port: container.lookup_port!,
      path: path
    )
  end

  private def generate_container_probe_http_get(container : Manifest::Shared::Container, http_check : Manifest::Handler::Http)
    Pyrite::Api::Core::V1::HTTPGetAction.new(
      path: http_check.path,
      port: container.lookup_port(http_check.port).not_nil!,
      host: http_check.host,
      scheme: http_check.scheme,
      http_headers: stringify_hash_values(http_check.headers).try(&.map { |k, v| Pyrite::Api::Core::V1::HTTPHeader.new(name: k, value: v) })
    )
  end

  private def generate_container_probe_tcp_socket(container : Manifest::Shared::Container, tcp : Nil)
  end

  private def generate_container_probe_tcp_socket(container : Manifest::Shared::Container, enabled : Bool)
    Pyrite::Api::Core::V1::TCPSocketAction.new(
      port: container.lookup_port!
    )
  end

  private def generate_container_probe_tcp_socket(container : Manifest::Shared::Container, port : String | Int32)
    Pyrite::Api::Core::V1::TCPSocketAction.new(
      port: container.lookup_port port
    )
  end

  private def generate_container_probe_tcp_socket(container : Manifest::Shared::Container, tcp : Manifest::Handler::Tcp)
    Pyrite::Api::Core::V1::TCPSocketAction.new(
      port: container.lookup_port tcp.port
    )
  end

  private def generate_container_probe_exec(container : Manifest::Shared::Container, exec : Nil)
  end

  private def generate_container_probe_exec(container : Manifest::Shared::Container, command : String)
    generate_container_probe_exec container, command.split(" ")
  end

  private def generate_container_probe_exec(container : Manifest::Shared::Container, exec : Manifest::Handler::Exec)
    generate_container_probe_exec container, exec.command
  end

  private def generate_container_probe_exec(container : Manifest::Shared::Container, command : Array(String))
    Pyrite::Api::Core::V1::ExecAction.new command: command
  end

  # Volume Mounts
  private def generate_container_volume_mounts(volumes : VolumeMountMap)
    volumes.map do |name, spec|
      raise Error.new("Invalid volume name: #{name}") unless manifest.volumes.try(&.[name]?)
      volume_name = [self.name, name].join('-')
      generate_container_volume_mount(volume_name, spec)
    end
  end

  private def generate_container_volume_mounts(any)
  end

  private def generate_container_volume_mount(volume_name : String, mount_path : String)
    Pyrite::Api::Core::V1::VolumeMount.new(
      name: volume_name,
      mount_path: mount_path
    )
  end

  private def generate_container_volume_mount(volume_name : String, spec : Manifest::Shared::Container::VolumeMount)
    Pyrite::Api::Core::V1::VolumeMount.new(
      name: volume_name,
      mount_path: spec.mount_path,
      mount_propagation: spec.mount_propagation,
      read_only: spec.read_only,
      sub_path: spec.sub_path
    )
  end

  # Environment
  private def generate_container_env(container)
    return if container.env.empty?
    container.env.map do |key, value|
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

  private def expand_env(key : String, value)
    Pyrite::Api::Core::V1::EnvVar.new(name: key, value: value.to_s)
  end

  private def expand_env_config_map(key : String)
    raise ValidationError.new "ConfigMap `#{key}` not defined in cluster: `#{cluster_name}`." unless cluster_config_map.has_key? key
    Pyrite::Api::Core::V1::ConfigMapKeySelector.new(key: key, name: name)
  end

  private def expand_env_config_map(key_ref : Manifest::Env::KeyRef)
    Pyrite::Api::Core::V1::ConfigMapKeySelector.new(key: key_ref.key, name: key_ref.name, optional: key_ref.optional)
  end

  private def expand_env_secret(key : String)
    raise ValidationError.new "Secret `#{key}` not defined in cluster: `#{cluster_name}`." unless combined_secrets.has_key?(key) || secrets_disabled?
    Pyrite::Api::Core::V1::SecretKeySelector.new(key: key, name: name)
  end

  private def expand_env_secret(key_ref : Manifest::Env::KeyRef)
    Pyrite::Api::Core::V1::SecretKeySelector.new(key: key_ref.key, name: key_ref.name, optional: key_ref.optional)
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

  private def generate_security_context
    if (security_context = manifest.security_context)
      Pyrite::Api::Core::V1::PodSecurityContext.new(
        fs_group: security_context.fs_group,
        run_as_non_root: security_context.run_as_non_root,
        run_as_user: security_context.run_as_user,
        se_linux_options: security_context.se_linux_options,
        supplemental_groups: security_context.supplemental_groups,
      )
    end
  end

  private def generate_security_context(_nil : Nil) : Nil
  end

  private def generate_security_context(security_context : Manifest::Shared::Container::SecurityContext)
    Pyrite::Api::Core::V1::SecurityContext.new(
      allow_privilege_escalation: security_context.allow_privilege_escalation,
      capabilities: security_context.capabilities,
      privileged: security_context.privileged,
      read_only_root_filesystem: security_context.read_only_root_filesystem,
      run_as_non_root: security_context.run_as_non_root,
      run_as_user: security_context.run_as_user,
      se_linux_options: security_context.se_linux_options,
    )
  end

  private def generate_exec_array(string : String)
    generate_exec_array string.split(" ")
  end

  private def generate_exec_array(strings : Array(String))
    strings
  end

  private def generate_exec_array(strings : Nil) : Nil
  end

  private def generate_container_lifecycle(container : Manifest::Shared::Container, spec : Manifest::Shared::Container::Lifecycle)
    Pyrite::Api::Core::V1::Lifecycle.new(
      post_start: generate_container_lifecycle_hook(container, spec.post_start),
      pre_stop: generate_container_lifecycle_hook(container, spec.pre_stop)
    )
  end

  private def generate_container_lifecycle(container : Manifest::Shared::Container, spec : Nil) : Nil
  end

  private def generate_container_lifecycle_hook(container : Manifest::Shared::Container, handler : Manifest::Handler)
    Pyrite::Api::Core::V1::Handler.new(
      exec: generate_container_probe_exec(container, handler.exec),
      http_get: generate_container_probe_http_get(container, handler.http),
      tcp_socket: generate_container_probe_tcp_socket(container, handler.tcp)
    )
  end

  private def generate_container_lifecycle_hook(container : Manifest::Shared::Container, spec : Nil) : Nil
  end

  private def generate_image_pull_secrets(_nil : Nil) : Nil
  end

  private def generate_image_pull_secrets(creds : Array(String | Manifest::Shared::PullSecretCredentials))
    creds.map do |cred|
      generate_image_pull_secret cred
    end
  end

  private def generate_image_pull_secret(name : String)
    Pyrite::Api::Core::V1::LocalObjectReference.new name: NameCleaner.clean(name)
  end

  private def generate_image_pull_secret(cred : Manifest::Shared::PullSecretCredentials)
    generate_image_pull_secret [name, cred.server].compact.join('-')
  end
end
