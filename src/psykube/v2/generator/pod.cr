class Psykube::V2::Generator::Pod < ::Psykube::Generator
  include Concerns::PodHelper
  include Concerns::CronJobHelper
  cast_manifest Manifest::Pod

  def result
    Pyrite::Api::Core::V1::Pod.new(
      metadata: generate_metadata,
      spec: generate_pod_spec
    )
  end
end
