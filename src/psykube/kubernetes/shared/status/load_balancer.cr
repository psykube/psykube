require "../../concerns/mapping"

class Psykube::Kubernetes::Shared::Status::LoadBalancer
  Kubernetes.mapping(
    ingress: Ingress
  )
end

require "./load_balancer/*"
