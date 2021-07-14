require "uuid"

class Psykube::Generator::InlineJob < ::Psykube::Generator
  include Concerns::PodHelper
  cast_manifest Manifest::Deployment | Manifest::StatefulSet | Manifest::DaemonSet | Manifest::Pod

  protected def result(name)
    raise Error.new("unknown job: #{name}") unless job = manifest.jobs.try(&.[name]?)
    Pyrite::Api::Core::V1::List.new(
      items: ([] of Pyrite::Kubernetes::Resource?).tap do |list|
        # Prepare RBAC
        list << ServiceAccount.result(self)
        list.concat Role.result(self)
        list.concat RoleBinding.result(self)
        list.concat ClusterRole.result(self)
        list.concat ClusterRoleBinding.result(self)

        # Set Config details
        list << ConfigMap.result(self)
        list << Secret.result(self)
        list.concat ImagePullSecret.result(self)

        # Add Volumes
        unless manifest.type == "StatefulSet"
          list.concat PersistentVolumeClaims.result(self)
        end

        # Add podable object
        list << Pyrite::Api::Batch::V1::Job.new(
          metadata: generate_metadata(name: "#{self.name}-#{name}-#{UUID.random}"),
          spec: generate_job(job)
        )
      end.compact
    )
  end

  private def generate_job(job : Manifest::Shared::InlineJob)
    generate_job_spec(job, "InlineJob").tap do |job_spec|
      job_spec.not_nil!.active_deadline_seconds = job.active_deadline
      job_spec.not_nil!.template.not_nil!.tap do |template|
        spec = template.not_nil!.spec.not_nil!
        spec.restart_policy = "Never"
        spec.init_containers = nil
        spec.containers = [spec.containers.first.tap do |container|
          container.liveness_probe = nil
          container.readiness_probe = nil
          container.ports = nil
          container.args = nil
          container.resources = nil
          container.command = generate_exec_array(job.command)
        end]
      end
    end
  end

  private def generate_job(command : String | Array(String))
    generate_job_spec(nil, "InlineJob").tap do |job_spec|
      job_spec.not_nil!.active_deadline_seconds = 300
      job_spec.not_nil!.template.not_nil!.tap do |template|
        spec = template.spec.not_nil!
        spec.restart_policy = "Never"
        template.metadata.not_nil!.labels.not_nil!["role"] = "job"
        spec.init_containers = nil
        spec.containers = [spec.containers.first.tap do |container|
          container.liveness_probe = nil
          container.readiness_probe = nil
          container.ports = nil
          container.args = nil
          container.resources = nil
          container.args = generate_exec_array(command)
        end]
      end
    end
  end
end
