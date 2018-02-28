require "./concerns/*"

abstract class Psykube::V1::Generator
  class Job < Generator
    class InvalidHealthcheck < Exception; end

    include Concerns::PodHelper

    protected def result
      Pyrite::Api::Batch::V1::Job.new(
        metadata: generate_metadata,
        spec: Pyrite::Api::Batch::V1::JobSpec.new(
          selector: generate_selector,
          parallelism: manifest.parallelism,
          completions: manifest.completions,
          template: generate_pod_template
        )
      )
    end
  end
end
