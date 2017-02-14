require "../concerns/mapping"

class Psykube::Kubernetes::Shared::NetworkStatus
  Kubernetes.mapping(
    load_balancer: {type: LoadBalancer, setter: false, nilable: true}
  )
end

require "./network_status/*"
