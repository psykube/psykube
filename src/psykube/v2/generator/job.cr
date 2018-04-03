class Psykube::V2::Generator::Job < ::Psykube::Generator
  include Concerns::PodHelper
  cast_manifest Manifest::Job

  protected def result
    Pyrite::Api::Batch::V1::Job.new(
      metadata: generate_metadata,
      spec: generate_job_spec
    )
  end
end
