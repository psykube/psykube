require "./concerns/*"

class Psykube::V1::Generator::ReplicationController < ::Psykube::Generator
  include Concerns::PodHelper
  cast_manifest Manifest

  protected def result
    Pyrite::Api::Core::V1::ReplicationController.new(
      metadata: generate_metadata,
      spec: Pyrite::Api::Core::V1::ReplicationControllerSpec.new(
        selector: generate_selector.match_labels,
        replicas: cluster.replicas || manifest.replicas,
        template: generate_pod_template
      )
    )
  end
end
