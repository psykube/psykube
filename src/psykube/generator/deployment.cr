require "../kubernetes/deployment"
require "./concerns/*"

class Psykube::Generator
  class Deployment < Generator
    include Concerns::Volumes

    alias Volume = Kubernetes::Deployment::Spec::Template::Spec::Volume
    alias Container = Kubernetes::Deployment::Spec::Template::Spec::Container

    protected def result
      Kubernetes::Deployment.new(manifest.name).tap do |deployment|
        deployment.spec.template.spec.volumes = generate_volumes
        deployment.spec.template.spec.containers << generate_container
      end
    end

    private def generate_volumes
      manifest_volumes.map do |mount_path, spec|
        generate_volume(mount_path, spec)
      end
    end

    def generate_volume(mount_path : String, size : String)
      volume_name = name_from_mount_path(mount_path)
      Volume.new(volume_name).tap do |volume|
        volume.persistent_volume_claim = Volume::PersistentVolumeClaim.new(volume_name)
      end
    end

    def generate_volume(mount_path : String, volume : Manifest::Volume)
      volume_name = name_from_mount_path(mount_path)
      kube_volume = (volume.spec ? volume.spec : Volume.new(volume_name)).as(Volume)
      kube_volume.persistent_volume_claim =
        generate_volume_claim(mount_path, volume.claim)
      kube_volume
    end

    def generate_volume_claim(mount_path : String, volume_claim : Nil)
    end

    def generate_volume_claim(mount_path : String, volume_claim : Manifest::Volume::Claim)
      volume_name = name_from_mount_path(mount_path)
      Volume::PersistentVolumeClaim.new(volume_name, volume_claim.read_only)
    end

    private def generate_container
      Container.new(manifest.name, container_image).tap do |container|
        container.env = generate_container_env
        container.volume_mounts = generate_container_volume_mounts(manifest.volumes)
        container.liveness_probe = generate_container_liveness_probe(manifest.healthcheck)
        container.readiness_probe = generate_container_readiness_probe(manifest.healthcheck)
        container.ports = generate_container_ports(manifest.ports)
      end
    end

    private def generate_container_ports(ports : Nil)
    end

    private def generate_container_ports(ports : Hash(String, UInt16))
      ports.map do |name, port|
        Kubernetes::Deployment::Spec::Template::Spec::Container::Port.new(name, port)
      end
    end

    private def generate_container_liveness_probe(healthcheck : Nil)
    end

    private def generate_container_liveness_probe(healthcheck : Bool)
      Container::Probe.new.tap do |probe|
        probe.http_get = Container::Action::HttpGet.new(lookup_port "default")
      end
    end

    private def generate_container_liveness_probe(healthcheck : Manifest::Healthcheck)
      Container::Probe.new.tap do |probe|
        probe.http_get = generate_container_readiness_probe_http_get(healthcheck.http)
        probe.tcp_socket = generate_container_readiness_probe_tcp_socket(healthcheck.tcp)
        probe.exec = generate_container_readiness_probe_exec(healthcheck.exec)
      end
    end

    private def generate_container_readiness_probe_http_get(http : Nil)
    end

    private def generate_container_readiness_probe_tcp_socket(tcp : Nil)
    end

    private def generate_container_readiness_probe_exec(exec : Nil)
    end

    private def generate_container_readiness_probe_http_get(http_check : Manifest::Healthcheck::Http)
      Container::Action::HttpGet.new(lookup_port http_check.port) do |http|
        http.path = http_check.path
        http.host = http_check.host
        http.scheme = http_check.scheme
        http_headers = Container::Action::HttpGet::HttpHeader.from_hash(http_check.headers)
        http.http_headers = http_headers unless http_headers.empty?
      end
    end

    private def generate_container_readiness_probe_tcp_socket(tcp : Manifest::Healthcheck::Tcp)
      Container::Action::TcpSocket.new(lookup_port tcp.port)
    end

    private def generate_container_readiness_probe_exec(exec : Manifest::Healthcheck::Exec)
      Container::Action::Exec.new(exec.command)
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

    private def generate_container_volume_mounts(volumes : Nil)
    end

    private def generate_container_volume_mounts(volumes : Manifest::VolumeMap)
      volumes.map do |mount_path, volume|
        volume_name = name_from_mount_path(mount_path)
        Container::VolumeMount.new(volume_name, mount_path)
      end
    end

    private def generate_container_env
      env_with_ports.map do |key, value|
        expand_env(key, value)
      end
    end

    private def expand_env(key : String, value : Manifest::Env)
      value_from = Container::Env::ValueFrom.new.tap do |value_from|
        if value.config_map
          value_from.config_map_key_ref = expand_env_config_map(value.config_map)
        end

        if value.secret
          value_from.secret_key_ref = expand_env_secret(value.config_map)
        end
      end
      Container::Env.new(key, value_from)
    end

    private def expand_env(key : String, value : String)
      Container::Env.new(key, value)
    end

    private def expand_env_config_map(value : Nil)
    end

    private def expand_env_config_map(key : String)
      Container::Env::ValueFrom::KeyRef.new(manifest.name, key)
    end

    private def expand_env_config_map(key_ref : Manifest::Env::KeyRef)
      Container::Env::ValueFrom::KeyRef.new(key_ref.name, key_ref.key)
    end

    private def expand_env_secret(value : Nil)
    end

    private def expand_env_secret(key : String)
      Container::Env::ValueFrom::KeyRef.new(manifest.name, key)
    end

    private def expand_env_secret(key_ref : Manifest::Env::KeyRef)
      Container::Env::ValueFrom::KeyRef.new(key_ref.name, key_ref.key)
    end

    private def env_with_ports
      port_env = {"PORT" => lookup_port("default").to_s}
      manifest.port_map.each_with_object(manifest.env.dup) do |(name, port), env|
        env["#{name.underscore.upcase}_PORT"] = port.to_s
      end
    end
  end
end
