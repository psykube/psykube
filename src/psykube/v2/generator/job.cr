class Psykube::V2::Generator::Job < Generator
  include Concerns::PodHelper

  protected def result
    Pyrite::Api::Batch::V1::Job.new(
      metadata: generate_metadata,
      spec: Pyrite::Api::Batch::V1::JobSpec.new(
        parallelism: manifest.parallelism,
        completions: manifest.completions,
        template: generate_pod_template
      )
    )
  end
end
