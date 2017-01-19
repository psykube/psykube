require "../../concerns/mapping"

class Psykube::Kubernetes::Shared::Status::LoadBalancer
  Kubernetes.mapping(
    ingress: Array(Ingress)?
  )
end

require "./load_balancer/*"
