require "../kubernetes/list"
require "../kubernetes/service"
require "../kubernetes/ingress"

class Psykube::Generator
  module List
    @list : Kubernetes::List
    getter list

    private def generate_list
      Kubernetes::List.new.tap do |list|
        persistent_volume_claims.as(Array(Kubernetes::PersistentVolumeClaim)).each do |pvc|
          list << pvc
        end
        list << config_map.as(Kubernetes::ConfigMap) if config_map
        list << secret.as(Kubernetes::Secret) if secret
        list << deployment
        if service
          list << service.as(Kubernetes::Service)
          list << ingress.as(Kubernetes::Ingress) if ingress
        end
      end
    end
  end
end
