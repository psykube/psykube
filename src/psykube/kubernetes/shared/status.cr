require "yaml"

class Psykube::Kubernetes::Shared::Status
  YAML.mapping(
    loadBalancer: {type: Shared::Status::LoadBalancer, setter: false}
  )
end

require "./status/*"
