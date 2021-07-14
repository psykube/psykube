class Psykube::Generator::InlineCronJob < ::Psykube::Generator
  include Concerns::PodHelper
  cast_manifest Manifest::Deployment | Manifest::StatefulSet | Manifest::DaemonSet | Manifest::Pod

  protected def result
    @role = "InlineCronJob"
    return [] of Pyrite::Api::Batch::V1beta1::CronJob if manifest.cron_jobs.nil?
    manifest.cron_jobs.not_nil!.map do |name, manifest|
      generate_cron_job(name, manifest)
    end
  end

  def generate_cron_job(name : String, manifest : Manifest::Shared::InlineCronJob)
    Pyrite::Api::Batch::V1beta1::CronJob.new(
      metadata: generate_metadata(name: "#{self.name}-#{name}"),
      spec: Pyrite::Api::Batch::V1beta1::CronJobSpec.new(
        schedule: manifest.schedule,
        suspend: manifest.suspend,
        failed_jobs_history_limit: manifest.failed_jobs_history_limit,
        successful_jobs_history_limit: manifest.successful_jobs_history_limit,
        concurrency_policy: manifest.concurrency_policy,
        job_template: generate_job_template(manifest, "InlineCronJob").tap do |job_template|
          job_template.not_nil!.tap do |template|
            spec = template.spec.not_nil!.template.not_nil!.spec.not_nil!
            template.spec.not_nil!.template.metadata.not_nil!.labels.not_nil!["role"] = "cron"
            spec.init_containers = nil
            spec.containers = [spec.containers.first.tap do |container|
              container.liveness_probe = nil
              container.readiness_probe = nil
              container.ports = nil
              container.args = generate_exec_array(manifest.args)
              container.resources = nil
              container.command = generate_exec_array(manifest.command)
            end]
          end
        end
      )
    )
  end
end
