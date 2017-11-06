require "./concerns/*"

abstract class Psykube::Generator
  class Pod < Generator
    include Concerns::PodHelper

    protected def result
      Pyrite::Api::Core::V1::Pod.new(
        metadata: generate_metadata,
        spec: generate_pod_spec
      )
    end
  end
end
