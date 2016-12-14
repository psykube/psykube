require "yaml"

class Psykube::Kubernetes::Service::Status
  YAML.mapping(
    loadBalancer: {type: Psykube::Kubernetes::Service::Status::LoadBalancer, setter: false}
  )
end

require "./status/*"
