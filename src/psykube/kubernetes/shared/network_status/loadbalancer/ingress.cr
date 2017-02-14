require "../../../concerns/mapping"

class Psykube::Kubernetes::Shared::NetworkStatus::LoadBalancer::Ingress
  Kubernetes.mapping(
    ip: {type: String, setter: false},
    hostname: {type: String, setter: false}
  )
end
