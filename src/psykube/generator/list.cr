require "../kubernetes/list"

abstract class Psykube::Generator
  class List < Generator
    protected def result
      Kubernetes::List.new do |list|
        list.metadata.namespace = namespace

        list << ConfigMap.result(self)
        list << Secret.result(self)
        list << Autoscale.result(self)

        # Generate the right podable type
        podable = case manifest.type
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

        list << podable

        # Add Service
        if service = Service.result(self)
          list << service
          list << Ingress.result(self)
        end

        # Add PVC
        unless podable.is_a? Kubernetes::StatefulSet
          list.concat PersistentVolumeClaims.result(self)
        end
      end
    end
  end
end
