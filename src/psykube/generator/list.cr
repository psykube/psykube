require "../kubernetes/list"

class Psykube::Generator
  class List < Generator
    protected def result
      Kubernetes::List.new do |list|
        list.metadata.namespace = namespace

        list << ConfigMap.result(self)
        list << Secret.result(self)
        list << Autoscale.result(self)

        # Generate the right podable type
        case manifest.type
        when "Deployment"
          list << Deployment.result(self)
        when "ReplicationController"
          list << ReplicationController.result(self)
          # when "Job"
          #   list << Job.result(self)
          # when "StatefulSet"
          #   list << StatefulSet.result(self)
          # when "ReplicaSet"
          #   list << ReplicaSet.result(self)
        when "Pod"
          list << Pod.result(self)
        else
          raise "Invalid type: `#{manifest.type}`"
        end

        # Add Service
        if service = Service.result(self)
          list << service
          list << Ingress.result(self)
        end

        # Add PVC
        unless manifest.type == "StatefulSet"
          list.concat PersistentVolumeClaims.result(self)
        end
      end
    end
  end
end
