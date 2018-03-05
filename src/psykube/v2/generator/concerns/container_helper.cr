require "./env_helper"

module Psykube::V2::Generator::Concerns::ContainerHelper
  include EnvHelper

  # Containers
  def generate_containers(containers)
    containers.map_with_index do |(container_name, container), index|
      generate_container(container_name, container, @actor.build_contexts[index].image)
    end
  end

  def generate_init_containers(init_containers)
    return if init_containers.empty?
    init_containers.map_with_index do |(container_name, container), index|
      generate_container(container_name, container, @actor.init_build_contexts[index].image)
    end
  end

  private def generate_container(container_name, container, image)
    Pyrite::Api::Core::V1::Container.new(
      name: container_name,
      image: image,
      env: generate_container_env(container),
      volume_mounts: VolumeHelper.generate_container_volume_mounts(container.volumes),
      liveness_probe: ProbeHelper.generate_container_liveness_probe(container, container.healthcheck),
      readiness_probe: ProbeHelper.generate_container_readiness_probe(container, container.readycheck || container.healthcheck),
      resources: generate_container_resources(container),
      ports: generate_container_ports(container.ports),
      command: generate_container_command(container.command),
      args: container.args
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

  # Commands
  private def generate_container_command(command : String)
    [command]
  end

  private def generate_container_command(commands : Array(String)?)
    commands
  end
end
