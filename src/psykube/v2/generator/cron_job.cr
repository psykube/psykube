class Psykube::V2::Generator::CronJob < ::Psykube::Generator
  include Concerns::PodHelper
  cast_manifest Manifest::CronJob

  protected def result
    Pyrite::Api::Batch::V1beta1::CronJob.new(
      metadata: generate_metadata,
      spec: Pyrite::Api::Batch::V1beta1::CronJobSpec.new(
        schedule: manifest.schedule,
        suspend: manifest.suspend,
        failed_jobs_history_limit: manifest.failed_jobs_history_limit,
        successful_jobs_history_limit: manifest.successful_jobs_history_limit,
        concurrency_policy: manifest.concurrency_policy,
        job_template: generate_job_template,
      )
    )
  end
end
