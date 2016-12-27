require "../../concerns/mapping"

class Psykube::Kubernetes::Service::Status
  Kubernetes.mapping(
    loadBalancer: {type: Shared::Status::LoadBalancer, setter: false}
  )
end

require "../shared/status/*"
