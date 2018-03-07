require "./pod_helper"

module Psykube::V2::Generator::Concerns::JobHelper
  include PodHelper

  private def generate_job_spec(job : Manifest::Shared::InlineJob)
    generate_job_spec(manifest: job, containers: { "job" => job.container })
  end

  private def generate_job_spec(command : String)
    generate_job_spec [command]
  end

  private def generate_job_spec(container : Manifest::Shared::Container)
    generate_job_spec(Manifest::Shared::InlineJob.new(container: container))
  end

  private def generate_job_spec(command : Array(String))
    container = manifest.containers.values.first.dup
    container.command = command
    generate_job_spec(Manifest::Shared::InlineJob.new(container: container))
  end

  private def generate_job_spec(job : Manifest::Shared::InlineJobRef)
    container = manifest.containers[job.container].dup
    container.command = job.command
    container.args = job.args
    container.volumes.merge! job.volumes
    container.env.merge! job.env
    generate_job_spec(manifest: job, containers: { job.container => container })
  end

  private def generate_job_spec(manifest : Manifest::Shared::InlineJob | Manifest::Shared::InlineJobRef, containers : ContainerMap)
    Pyrite::Api::Batch::V1::JobSpec.new(
      active_deadline_seconds: manifest.active_deadline,
      completions: manifest.completions,
      backoff_limit: manifest.backoff_limit,
      parallelism: manifest.parallelism,
      template: generate_pod_template(manifest, containers)
    )
  end

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
