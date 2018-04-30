class Psykube::V2::Generator::List < ::Psykube::Generator
  protected def result
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
        list << podable

        # Expose Service & Ingress
        case manifest.type
        when "Deployment", "Pod", "DaemonSet", "StatefulSet"
          list.concat Service.result(self)
          list << Ingress.result(self)
        end

        # Apply Autoscaling
        if manifest.type == "Deployment"
          list << Autoscale.result(self)
        end
      end.compact
    )
  end

  private def podable
    case manifest.type
    when "Deployment"
      Deployment.result(self)
    when "Cron"
      CronJob.result(self)
    when "Job"
      Job.result(self)
    when "StatefulSet"
      StatefulSet.result(self)
    when "DaemonSet"
      DaemonSet.result(self)
    when "Pod"
      Pod.result(self)
    else
      raise "Invalid type: `#{manifest.type}`"
    end
  end
end
