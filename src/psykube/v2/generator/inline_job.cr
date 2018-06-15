class Psykube::V2::Generator::InlineJob < ::Psykube::Generator
  include Concerns::PodHelper
  cast_manifest Manifest::Deployment | Manifest::StatefulSet | Manifest::DaemonSet | Manifest::Pod

  protected def result(name)
    raise Error.new("unknown job: #{name}") unless job = manifest.jobs.try(&.[name]?)
    Pyrite::Api::Batch::V1::Job.new(
      metadata: generate_metadata(generate_name: "#{self.name}-#{name}"),
      spec: generate_job(job)
    )
  end

  private def generate_job(job : Manifest::Shared::InlineJob)
    generate_job_spec(job).tap do |job_template|
      job_template.tap do |template|
        spec = job_template.template.not_nil!.spec.not_nil!
        spec.init_containers = nil
        spec.containers = [spec.containers.first.tap do |container|
          container.liveness_probe = nil
          container.readiness_probe = nil
          container.ports = nil
          container.args = nil
          container.resources = nil
          container.command = generate_container_command(job.command)
        end]
      end
    end
  end

  private def generate_job(command : String | Array(String))
    generate_job_spec(nil).tap do |job_template|
      job_template.tap do |template|
        spec = job_template.template.not_nil!.spec.not_nil!
        spec.init_containers = nil
        spec.containers = [spec.containers.first.tap do |container|
          container.liveness_probe = nil
          container.readiness_probe = nil
          container.ports = nil
          container.args = nil
          container.resources = nil
          container.command = generate_container_command(command)
        end]
      end
    end
  end
end
