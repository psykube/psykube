class Psykube::V1::Generator::ReplicaSet < ::Psykube::Generator
  include Concerns::PodHelper
  cast_manifest Manifest

  protected def result
    Pyrite::Api::Apps::V1::ReplicaSet.new(
      metadata: generate_metadata,
      spec: Pyrite::Api::Apps::V1::ReplicaSetSpec.new(
        selector: generate_selector,
        replicas: cluster.replicas || manifest.replicas,
        template: generate_pod_template
      )
    )
  end
end
