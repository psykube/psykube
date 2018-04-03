class Psykube::V1::Generator::Job < ::Psykube::Generator
  include Concerns::PodHelper
  cast_manifest Manifest

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
