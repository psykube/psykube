require "../kubernetes/deployment"

class Psykube::Generator
  module Deployment
    alias Volume = Psykube::Kubernetes::Deployment::Spec::Template::Spec::Volume
    alias Container = Psykube::Kubernetes::Deployment::Spec::Template::Spec::Container
    @deployment : Psykube::Kubernetes::Deployment
    getter deployment

    private def generate_deployment
      Psykube::Kubernetes::Deployment.new(manifest.name).tap do |deployment|
        deployment.spec.template.spec.volumes = generate_deployment_volumes(manifest.volumes)
        deployment.spec.template.spec.containers << generate_deployment_container
      end
    end

    private def generate_deployment_volumes(volumes : Nil)
    end

    private def generate_deployment_volumes(volumes : Hash(String, Psykube::Manifest::Volume | String))
      volumes.map do |mount_path, spec|
        generate_deployment_volume(mount_path, spec)
      end
    end

    def generate_deployment_volume(mount_path : String, size : String)
      volume_name = name_from_mount_path(mount_path)
      Volume.new(volume_name).tap do |volume|
        volume.persistent_volume_claim = Volume::PersistentVolumeClaim.new(volume_name)
      end
    end

    def generate_deployment_volume(mount_path : String, volume : Psykube::Manifest::Volume)
      volume_name = name_from_mount_path(mount_path)
      kube_volume = (volume.spec ? volume.spec : Volume.new(volume_name)).as(Volume)
      kube_volume.persistent_volume_claim =
        generate_deployment_volume_claim(mount_path, volume.claim)
      kube_volume
    end

    def generate_deployment_volume_claim(mount_path : String, volume_claim : Nil)
    end

    def generate_deployment_volume_claim(mount_path : String, volume_claim : Psykube::Manifest::Volume::Claim)
      volume_name = name_from_mount_path(mount_path)
      Volume::PersistentVolumeClaim.new(volume_name, volume_claim.read_only)
    end

    private def name_from_mount_path(mount_path : String)
      [cluster_name, manifest.name, mount_path.gsub(/\//, "-")].join('-')
    end

    private def generate_deployment_container
      Container.new(manifest.name, container_image).tap do |container|
        container.env = generate_deployment_container_env
        container.volume_mounts = generate_deployment_container_volume_mounts(manifest.volumes)
        container.liveness_probe = generate_deployment_container_liveness_probe(manifest.healthcheck)
        container.readiness_probe = generate_deployment_container_readiness_probe(manifest.healthcheck)
        container.ports = generate_deployment_container_deployment_ports(manifest.ports)
      end
    end

    private def generate_deployment_container_deployment_ports(ports : Nil)
    end

    private def generate_deployment_container_deployment_ports(ports : Hash(String, UInt16))
    end

    private def generate_deployment_container_liveness_probe(healthcheck : Nil)
    end

    private def generate_deployment_container_liveness_probe(healthcheck : Bool)
      Container::Probe.new.tap do |probe|
        probe.http_get = Container::Action::HttpGet.new(lookup_port "default")
      end
    end

    private def generate_deployment_container_liveness_probe(healthcheck : Manifest::Healthcheck)
      Container::Probe.new.tap do |probe|
        probe.http_get = generate_deployment_container_readiness_probe_http_get(healthcheck.http)
        probe.tcp_socket = generate_deployment_container_readiness_probe_tcp_socket(healthcheck.tcp)
        probe.exec = generate_deployment_container_readiness_probe_exec(healthcheck.exec)
      end
    end

    private def generate_deployment_container_readiness_probe_http_get(http : Nil)
    end

    private def generate_deployment_container_readiness_probe_tcp_socket(tcp : Nil)
    end

    private def generate_deployment_container_readiness_probe_exec(exec : Nil)
    end

    private def generate_deployment_container_readiness_probe_http_get(http_check : Manifest::Healthcheck::Http)
      Container::Action::HttpGet.new(lookup_port http_check.port) do |http|
        http.path = http_check.path
        http.host = http_check.host
        http.scheme = http_check.scheme
        http.http_headers = Container::Action::HttpGet::HttpHeader.from_hash(http_check.headers)
      end
    end

    private def generate_deployment_container_readiness_probe_tcp_socket(tcp : Manifest::Healthcheck::Tcp)
      Container::Action::TcpSocket.new(lookup_port tcp.port)
    end

    private def generate_deployment_container_readiness_probe_exec(exec : Manifest::Healthcheck::Exec)
      Container::Action::Exec.new(exec.command)
    end

    private def generate_deployment_container_readiness_probe(healthcheck : Nil)
    end

    private def generate_deployment_container_readiness_probe(healthcheck : Bool)
      generate_deployment_container_liveness_probe(healthcheck)
    end

    private def generate_deployment_container_readiness_probe(healthcheck : Manifest::Healthcheck)
      if healthcheck.readiness
        generate_deployment_container_liveness_probe(healthcheck)
      end
    end

    private def generate_deployment_container_volume_mounts(volumes : Nil)
    end

    private def generate_deployment_container_volume_mounts(volumes : Psykube::Manifest::VolumeMap)
      volumes.map do |mount_path, volume|
        volume_name = name_from_mount_path(mount_path)
        Container::VolumeMount.new(volume_name, mount_path)
      end
    end

    private def generate_deployment_container_env
      manifest.full_env.map do |key, value|
        expand_env(key, value)
      end
    end

    private def expand_env(key : String, value : Psykube::Manifest::Env)
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

    private def expand_env_config_map(key_ref : Psykube::Manifest::Env::KeyRef)
      Container::Env::ValueFrom::KeyRef.new(key_ref.name, key_ref.key)
    end

    private def expand_env_secret(value : Nil)
    end

    private def expand_env_secret(key : String)
      Container::Env::ValueFrom::KeyRef.new(manifest.name, key)
    end

    private def expand_env_secret(key_ref : Psykube::Manifest::Env::KeyRef)
      Container::Env::ValueFrom::KeyRef.new(key_ref.name, key_ref.key)
    end
  end
end
