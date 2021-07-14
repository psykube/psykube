class Psykube::Generator::Pod < ::Psykube::Generator
  include Concerns::PodHelper
  cast_manifest Manifest::Pod

  protected def result
    Pyrite::Api::Core::V1::Pod.new(
      metadata: generate_metadata(psykube_meta: false),
      spec: generate_pod_spec
    )
  end
end
