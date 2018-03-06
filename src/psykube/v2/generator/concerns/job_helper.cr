require "./pod_helper"

module Psykube::V2::Generator::Concerns::JobHelper
  include PodHelper

  private def generate_job_template(manifest, containers : ContainerMap)
    Pyrite::Api::Batch::V1beta1::JobTemplateSpec.new(
      spec: generate_job_spec(manifest, containers)
    )
  end

  private def generate_job_template
    Pyrite::Api::Batch::V1beta1::JobTemplateSpec.new(
      spec: generate_job_spec
    )
  end

  private def generate_job_spec
    Pyrite::Api::Batch::V1::JobSpec.new(
      active_deadline_seconds: manifest.active_deadline,
      completions: manifest.completions,
      backoff_limit: manifest.backoff_limit,
      parallelism: manifest.parallelism,
      template: generate_pod_template
    )
  end

  private def generate_job_spec(manifest, containers : ContainerMap)
    Pyrite::Api::Batch::V1::JobSpec.new(
      active_deadline_seconds: manifest.active_deadline,
      completions: manifest.completions,
      backoff_limit: manifest.backoff_limit,
      parallelism: manifest.parallelism,
      template: generate_pod_template(manifest, containers)
    )
  end
end
