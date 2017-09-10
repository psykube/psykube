require "./concerns/*"

abstract class Psykube::Generator
  class Job < Generator
    class InvalidHealthcheck < Exception; end

    include Concerns::PodHelper

    protected def result
      Kubernetes::Apis::Batch::V1::Job.new(
        metadata: generate_metadata,
        spec: Kubernetes::Apis::Batch::V1::JobSpec.new(
          selector: generate_selector,
          parallelism: manifest.parallelism,
          completions: manifest.completions,
          template: generate_pod_template
        )
      )
    end
  end
end
