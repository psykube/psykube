require "../../concerns/mapping"

class Psykube::Kubernetes::Service::Status
  Kubernetes.mapping(
    load_balancer: {type: Shared::Status::LoadBalancer, setter: false}
  )
end

require "../shared/status/*"
