require "../kubernetes/list"
require "../kubernetes/service"
require "../kubernetes/ingress"

class Psykube::Generator
  module List
    @list : Psykube::Kubernetes::List
    getter list

    private def generate_list
      Psykube::Kubernetes::List.new.tap do |list|
        list << config_map.as(Psykube::Kubernetes::ConfigMap) if config_map
        list << secret.as(Psykube::Kubernetes::Secret) if secret
        list << deployment
        if service
          list << service.as(Psykube::Kubernetes::Service)
          list << ingress.as(Psykube::Kubernetes::Ingress) if ingress
        end
      end
    end
  end
end
