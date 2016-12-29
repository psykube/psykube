require "../concerns/mapping"

class Psykube::Kubernetes::Shared::Status
  Kubernetes.mapping(
    load_balancer: {type: Shared::Status::LoadBalancer, setter: false, nilable: true}
  )
end

require "./status/*"
