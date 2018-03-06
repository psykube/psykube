require "./pod_helper"

module Psykube::V2::Generator::Concerns::JobHelper
  include PodHelper

  def generate_job(name : String)
    generate_job(name, manifest.jobs[name])
  end

  private def generate_job(name : String, command : String | Array(String))
    container_name = manifest.containers.keys.first
    container = manifest.containers[container_name].dup
    container.command = command
    generate_job(name, manifest: job, containers: {container_name => container})
  end

  private def generate_job(name : String, container : Manifest::Shared::Container)
    generate_job(name, manifest: job, containers: {"job" => container})
  end

  private def generate_job(name : String, job : Manifest::Shared::InlineJob)
    generate_job(name, manifest: job, containers: {"job" => job.container})
  end

  private def generate_job(name : String, job : Manifest::Shared::InlineJobRef)
    container = manifest.containers[job.container].dup
    container.command = job.command
    container.args = job.args
    container.volumes.merge! job.volumes
    container.env.merge! job.env
    generate_job(name, manifest: job, containers: {job.container => container})
  end

  private def generate_job(name : String, *, manifest, containers : ContainerMap)
    name = Psykube::NameCleaner.clean(name)
    Pyrite::Api::Batch::V1::Job.new(
      metadata: generate_metadata(generate_name: [self.name, name].join('-')),
      spec: generate_job_spec(manifest, containers)
    )
  end

  private def generate_job_template
    Pyrite::Api::Batch::V1beta1::JobTemplateSpec.new(
      metadata: generate_metadata,
      spec: generate_job_spec
    )
  end

  private def generate_job_template(*, manifest, containers : ContainerMap)
    Pyrite::Api::Batch::V1beta1::JobTemplateSpec.new(
      metadata: generate_metadata,
      spec: generate_job_spec(manifest, containers)
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
