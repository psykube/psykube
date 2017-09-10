abstract class Psykube::Generator
  class List < Generator
    protected def result
      Kubernetes::Api::V1::List.new(
        items: ([] of Kubernetes::Resource?).tap do |list|
          list << ConfigMap.result(self)
          list << Secret.result(self)
          list << (podable = Autoscale.result(self))
          list << generate_podable
          list << Service.result(self)
          list << Ingress.result(self)

          # Add PVCs
          unless podable.is_a? Kubernetes::Apis::Apps::V1beta1::StatefulSetSpec
            PersistentVolumeClaims.result(self).tap do |claims|
              list.concat(claims) if claims
            end
          end
        end.compact
      )
    end

    private def generate_podable
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
end
