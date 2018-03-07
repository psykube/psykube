class Psykube::V1::Generator::List < ::Psykube::Generator
  def result
    Pyrite::Api::Core::V1::List.new(
      items: ([] of Pyrite::Kubernetes::Resource?).tap do |list|
        list << ConfigMap.result(self)
        list << Secret.result(self)
        list << podable

        case manifest.type
        when "Deployment", "Pod", "DaemonSet", "StatefulSet", "ReplicaSet", "ReplicationController"
          list << Service.result(self)
          list << Ingress.result(self)
        end

        case manifest.type
        when "Deployment", "ReplicaSet", "ReplicationController"
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

  private def podable
    case manifest.type
    when "Deployment"
      Deployment.result(self)
    when "ReplicationController"
      ReplicationController.result(self)
    when "Job"
      Job.result(self)
    when "ReplicaSet"
      ReplicaSet.result(self)
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
