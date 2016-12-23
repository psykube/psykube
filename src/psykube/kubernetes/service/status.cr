require "yaml"

class Psykube::Kubernetes::Service::Status
  YAML.mapping(
    loadBalancer: {type: Shared::Status::LoadBalancer, setter: false}
  )
end

require "../shared/status/*"
