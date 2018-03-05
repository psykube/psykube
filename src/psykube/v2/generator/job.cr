class Psykube::V2::Generator::Job < ::Psykube::Generator
  include Concerns::JobHelper
  cast_manifest Manifest::Job

  def result
    Pyrite::Api::Batch::V1::Job.new(
      metadata: generate_metadata,
      spec: generate_job_spec
    )
  end
end
