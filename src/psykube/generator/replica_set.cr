require "./concerns/*"

abstract class Psykube::Generator
  class ReplicaSet < Generator
    class InvalidHealthcheck < Exception; end

    include Concerns::PodHelper

    protected def result
      Kubernetes::Apis::Extensions::V1beta1::ReplicaSet.new(
        metadata: generate_metadata,
        spec: Kubernetes::Apis::Extensions::V1beta1::ReplicaSetSpec.new(
          selector: generate_selector,
          replicas: manifest.replicas,
          template: generate_pod_template
        )
      )
    end
  end
end
