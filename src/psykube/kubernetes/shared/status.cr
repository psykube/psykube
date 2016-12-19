require "yaml"

class Psykube::Kubernetes::Shared::Status
  YAML.mapping(
    loadBalancer: {type: Psykube::Kubernetes::Shared::Status::LoadBalancer, setter: false}
  )
end

require "./status/*"
