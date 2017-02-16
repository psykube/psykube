require "../kubernetes/deployment"
require "../kubernetes/pod"
require "./concerns/*"

class Psykube::Generator
  class Deployment < Generator
    class InvalidHealthcheck < Exception; end

    include Concerns::Volumes

    alias Volume = Kubernetes::Pod::Spec::Volume
    alias Container = Kubernetes::Pod::Spec::Container

    protected def result
      Kubernetes::Deployment.new(manifest.name).tap do |deployment|
        deployment.metadata.namespace = namespace
        if spec = deployment.spec
          spec.template.spec.volumes = generate_volumes
          spec.template.spec.containers << generate_container
          spec.strategy = generate_strategy
          spec.progress_deadline_seconds = manifest.deploy_timeout
        end
      end
    end

    # Strategy
    private def generate_strategy
      Kubernetes::Deployment::Spec::Strategy.new(
        max_unavailable: manifest.max_unavailable,
        max_surge: manifest.max_surge
      )
    end

    # Containers
    private def generate_container
      Container.new(manifest.name, image).tap do |container|
        container.env = generate_container_env
        container.volume_mounts = generate_container_volume_mounts(manifest.volumes)
        container.liveness_probe = generate_container_liveness_probe(manifest.healthcheck)
        container.readiness_probe = generate_container_readiness_probe(manifest.healthcheck)
        container.ports = generate_container_ports(manifest.ports)
        container.command = generate_container_command(manifest.command)
        container.args = generate_container_args(manifest.args)
      end
    end

    # Volumes
    private def generate_volumes
      manifest_volumes.map do |mount_path, spec|
        generate_volume(mount_path, spec)
      end
    end

    private def generate_volume(mount_path : String, size : String)
      volume_name = name_from_mount_path(mount_path)
      Volume.new(volume_name).tap do |volume|
        volume.persistent_volume_claim = Volume::Source::PersistentVolumeClaim.new(volume_name)
      end
    end

    private def generate_volume(mount_path : String, volume : Manifest::Volume)
      volume_name = name_from_mount_path(mount_path)
      volume.to_deployment_volume(volume_name)
    end

    # Ports
    private def generate_container_ports(ports : Nil)
    end

    private def generate_container_ports(ports : Hash(String, UInt16))
      ports.map do |name, port|
        Container::Port.new(name, port)
      end
    end

    # Healthchecks
    private def generate_container_liveness_probe(healthcheck : Nil)
    end

    private def generate_container_liveness_probe(healthcheck : Bool)
      Container::Probe.new.tap do |probe|
        probe.http_get = Container::Action::HttpGet.new(lookup_port "default")
      end if manifest.service?
    end

    private def generate_container_liveness_probe(healthcheck : Manifest::Healthcheck)
      Container::Probe.new.tap do |probe|
        raise InvalidHealthcheck.new("Cannot perform http healthcheck without specifying ports.") if !manifest.ports && healthcheck.http
        raise InvalidHealthcheck.new("Cannot perform tcp healthcheck without specifying ports.") if !manifest.ports && healthcheck.tcp
        probe.http_get = generate_container_probe_http_get(healthcheck.http)
        probe.exec = generate_container_probe_exec(healthcheck.exec)
        probe.tcp_socket = generate_container_probe_tcp_socket(healthcheck.tcp)
      end
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

    private def generate_container_probe_http_get(http : Nil)
    end

    private def generate_container_probe_tcp_socket(tcp : Nil)
    end

    private def generate_container_probe_exec(exec : Nil)
    end

    private def generate_container_probe_http_get(http_check : Manifest::Healthcheck::Http)
      Container::Action::HttpGet.new(lookup_port http_check.port) do |http|
        http.path = http_check.path
        http.host = http_check.host
        http.scheme = http_check.scheme
        http_headers = Container::Action::HttpGet::HttpHeader.from_hash(http_check.headers)
        http.http_headers = http_headers unless http_headers.empty?
      end
    end

    private def generate_container_probe_tcp_socket(tcp : Manifest::Healthcheck::Tcp)
      Container::Action::TcpSocket.new(lookup_port tcp.port)
    end

    private def generate_container_probe_exec(exec : Manifest::Healthcheck::Exec)
      Container::Action::Exec.new(exec.command)
    end

    # Volume Mounts
    private def generate_container_volume_mounts(volumes : Nil)
    end

    private def generate_container_volume_mounts(volumes : Manifest::VolumeMap)
      volumes.map do |mount_path, volume|
        volume_name = name_from_mount_path(mount_path)
        Container::VolumeMount.new(volume_name, mount_path)
      end
    end

    # Environment
    private def generate_container_env
      env_with_ports.map do |key, value|
        expand_env(key, value)
      end
    end

    private def expand_env(key : String, value : Manifest::Env)
      value_from = Container::Env::ValueFrom.new.tap do |value_from|
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
      Container::Env.new(key, value_from)
    end

    private def expand_env(key : String, value : String)
      Container::Env.new(key, value)
    end

    private def expand_env_config_map(key : String)
      raise ValidationError.new "ConfigMap `#{key}` not defined in cluster: `#{cluster_name}`." unless cluster_config_map.has_key? key
      Container::Env::ValueFrom::KeyRef.new(manifest.name, key)
    end

    private def expand_env_config_map(key_ref : Manifest::Env::KeyRef)
      Container::Env::ValueFrom::KeyRef.new(key_ref.name, key_ref.key)
    end

    private def expand_env_secret(key : String)
      raise ValidationError.new "Secret `#{key}` not defined in cluster: `#{cluster_name}`." unless cluster_secrets.has_key? key
      Container::Env::ValueFrom::KeyRef.new(manifest.name, key)
    end

    private def expand_env_secret(key_ref : Manifest::Env::KeyRef)
      Container::Env::ValueFrom::KeyRef.new(key_ref.name, key_ref.key)
    end

    private def expand_env_field(field : String)
      Container::Env::ValueFrom::FieldRef.new(field)
    end

    private def expand_env_field(field_ref : Manifest::Env::FieldRef)
      Container::Env::ValueFrom::FieldRef.new(
        field_path: field_ref.path,
        api_version: field_ref.api_version
      )
    end

    private def expand_env_resource_field(resource_field : String)
      Container::Env::ValueFrom::ResourceFieldRef.new(resource_field)
    end

    private def expand_env_resource_field(field_ref : Manifest::Env::ResourceFieldRef)
      Container::Env::ValueFrom::ResourceFieldRef.new(
        resource: field_ref.resource,
        container_name: field_ref.container,
        divisor: field_ref.divisor
      )
    end

    private def env_with_ports
      return manifest_env unless manifest.service?
      port_env = {"PORT" => lookup_port("default").to_s}
      manifest.ports.each_with_object(manifest_env.dup) do |(name, port), env|
        env["#{name.underscore.upcase}_PORT"] = port.to_s
      end.merge(port_env)
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
end
