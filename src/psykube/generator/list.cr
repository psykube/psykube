require "../kubernetes/list"

class Psykube::Generator
  module List
    @list : Psykube::Kubernetes::List
    getter list

    private def generate_list
      Psykube::Kubernetes::List.new([
        config_map,
        # secret,
        # deployment,
        service,
        ingress
      ])
    end
  end
end
