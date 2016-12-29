require "../../../concerns/mapping"

class Psykube::Kubernetes::Shared::Status::LoadBalancer::Ingress
  Kubernetes.mapping(
    ip: {type: String, setter: false, nilable: true},
    hostname: {type: String, setter: false, nilable: true}
  )
end
