class Psykube::V2::Generator::InlineJob < ::Psykube::Generator
  include Concerns::JobHelper
  cast_manifest Manifest::Jobable

  getter job_name : String

  def initialize(manifest, actor, @job_name : String)
    initialize(manifest, actor)
  end

  def result
    job = manifest.jobs[job_name]? || raise("job not defined: #{job_name}")
    full_name = [name, job_name].join('-')
    Pyrite::Api::Batch::V1::Job.new(
      metadata: generate_metadata(name: nil, generate_name: full_name),
      spec: generate_job_spec(job)
    )
  end
end
