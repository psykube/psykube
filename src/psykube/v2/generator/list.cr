class Psykube::V1::Generator::List < Generator
  protected def result
    Pyrite::Api::Core::V1::List.new(
      items: ([] of Pyrite::Kubernetes::Resource?).tap do |list|
        podable = generate_podable
        list << ConfigMap.result(self)
        list << Secret.result(self)
        list << Autoscale.result(self)
        list << Service.result(self)
        list << Ingress.result(self)
        list << podable

        # Add PVCs
        unless podable.is_a? Pyrite::Api::Apps::V1beta1::StatefulSet
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
