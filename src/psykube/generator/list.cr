require "../kubernetes/list"
require "../kubernetes/service"
require "../kubernetes/ingress"

class Psykube::Generator
  class List < Generator
    protected def result
      Kubernetes::List.new do |list|
        list.concat PersistentVolumeClaims.result(self)
        list << ConfigMap.result(self)
        list << Secret.result(self)
        list << Deployment.result(self)
        if service = Service.result(self)
          list << service
          list << Ingress.result(self)
        end
      end
    end
  end
end
