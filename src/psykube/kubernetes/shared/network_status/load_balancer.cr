require "../../concerns/mapping"

class Psykube::Kubernetes::Shared::NetworkStatus::LoadBalancer
  Kubernetes.mapping(
    ingress: Array(Ingress)?
  )
end

require "./load_balancer/*"
