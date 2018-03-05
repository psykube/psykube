class Psykube::V1::Generator::ReplicaSet < ::Psykube::Generator
  include Concerns::PodHelper
  cast_manifest Manifest

  def result
    Pyrite::Api::Extensions::V1beta1::ReplicaSet.new(
      metadata: generate_metadata,
      spec: Pyrite::Api::Extensions::V1beta1::ReplicaSetSpec.new(
        selector: generate_selector,
        replicas: manifest.replicas,
        template: generate_pod_template
      )
    )
  end
end
