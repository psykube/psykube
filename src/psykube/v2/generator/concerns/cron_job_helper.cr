require "./job_helper"

module Psykube::V2::Generator::Concerns::CronJobHelper
  include JobHelper

  def generate_cron_jobs
    manifest.cron_jobs.map do |name, cron_job|
      generate_cron_job name, cron_job
    end
  end

  private def generate_cron_job(name : String, job : Manifest::Shared::InlineCronJob)
    generate_cron_job(name, manifest: job, containers: { "cron" => job.container })
  end

  private def generate_cron_job(name : String, job : Manifest::Shared::InlineCronJobRef)
    container = manifest.containers[job.container].dup
    container.command = job.command
    container.args = job.args
    container.volumes.merge! job.volumes
    container.env.merge! job.env
    generate_cron_job(name, manifest: job, containers: { job.container => container })
  end

  private def generate_cron_job(name : String, manifest : Manifest::Shared::InlineCronJob | Manifest::Shared::InlineCronJobRef, containers : ContainerMap)
    Pyrite::Api::Batch::V1beta1::CronJob.new(
      metadata: generate_metadata(name: [self.name, name].join('-')),
      spec: Pyrite::Api::Batch::V1beta1::CronJobSpec.new(
        schedule: manifest.schedule,
        suspend: manifest.suspend,
        failed_jobs_history_limit: manifest.failed_jobs_history_limit,
        successful_jobs_history_limit: manifest.successful_jobs_history_limit,
        concurrency_policy: manifest.concurrency_policy,
        job_template: generate_job_template(manifest: manifest, containers: containers),
      )
    )
  end
end
