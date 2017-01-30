require "../kubernetes/list"

class Psykube::Generator
  class List < Generator
    protected def result
      Kubernetes::List.new do |list|
        list.metadata.namespace = namespace
        list.concat PersistentVolumeClaims.result(self)
        list << ConfigMap.result(self)
        list << Secret.result(self)
        list << Deployment.result(self)
        if service = Service.result(self)
          list << service
          list << Ingress.result(self)
        end
        list << Autoscale.result(self)
      end
    end
  end
end
