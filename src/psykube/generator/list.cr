class Psykube::Generator
  module List
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
