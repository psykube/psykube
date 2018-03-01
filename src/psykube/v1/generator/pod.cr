class Psykube::V1::Generator::Pod < ::Psykube::Generator
  include Concerns::PodHelper
  cast_manifest Manifest

  protected def result
    Pyrite::Api::Core::V1::Pod.new(
      metadata: generate_metadata,
      spec: generate_pod_spec
    )
  end
end
