require "./container_helper"

module Psykube::V2::Generator::Concerns::PodHelper
  include ContainerHelper

  # Templates and specs
  private def generate_pod_template
    Pyrite::Api::Core::V1::PodTemplateSpec.new(
      spec: generate_pod_spec,
      metadata: Pyrite::Apimachinery::Apis::Meta::V1::ObjectMeta.new(
        labels: {"app" => name}
      )
    )
  end

  private def generate_pod_template(manifest, containers : ContainerMap, init_containers : ContainerMap = ContainerMap.new)
    Pyrite::Api::Core::V1::PodTemplateSpec.new(
      spec: generate_pod_spec(manifest: manifest, containers: containers, init_containers: init_containers),
      metadata: Pyrite::Apimachinery::Apis::Meta::V1::ObjectMeta.new(
        labels: {"app" => name}
      )
    )
  end

  private def generate_pod_spec
    generate_pod_spec(
      manifest: manifest,
      containers: manifest.containers,
      init_containers: manifest.init_containers
    )
  end

  private def generate_pod_spec(manifest, containers : ContainerMap, init_containers : ContainerMap = ContainerMap.new)
    Pyrite::Api::Core::V1::PodSpec.new(
      restart_policy: manifest.restart_policy,
      volumes: VolumeHelper.generate_volumes(manifest.volumes),
      containers: generate_containers(containers),
      init_containers: generate_init_containers(init_containers),
    )
  end
end
