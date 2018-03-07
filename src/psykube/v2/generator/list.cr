class Psykube::V2::Generator::List < ::Psykube::Generator
  def result
    Pyrite::Api::Core::V1::List.new(
      items: ([] of Pyrite::Kubernetes::Resource?).tap do |list|
        list << ConfigMap.result(self)
        list << Secret.result(self)
        list << primary_generator.result.as(Pyrite::Kubernetes::Resource)

        if manifest.type.is_a?(Manifest::Serviceable)
          list << Service.result(self)
          list << Ingress.result(self)
        end

        if manifest.type.is_a?(Manifest::Jobable)
          list += primary_generator.as(Concerns::CronJobHelper).generate_cron_jobs.as(Array(Pyrite::Kubernetes::Resource))
        end

        if manifest.type == "Deployment"
          list << Autoscale.result(self)
        end

        # Add PVCs
        unless manifest.type == "StatefulSet"
          PersistentVolumeClaims.result(self).tap do |claims|
            list.concat(claims) if claims
          end
        end
      end.compact
    )
  end

  private def primary_generator
    case manifest.type
    when "Deployment"
      Deployment.new(self)
    when "Cron"
      CronJob.new(self)
    when "StatefulSet"
      StatefulSet.new(self)
    when "DaemonSet"
      DaemonSet.new(self)
    when "Job"
      Job.new(self)
    when "Pod"
      Pod.new(self)
    else
      raise "Invalid type: `#{manifest.type}`"
    end
  end
end
