require "../concerns/mapping"

class Psykube::Kubernetes::Shared::Status
  Kubernetes.mapping(
    loadBalancer: {type: Shared::Status::LoadBalancer, setter: false}
  )
end

require "./status/*"
