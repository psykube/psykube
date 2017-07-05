require "./concerns/resource"
require "./shared/network_status"

class Psykube::Kubernetes::Ingress
  Resource.definition("extensions/v1beta1", "Ingress", {
    spec:   Spec?,
    status: {type: Shared::NetworkStatus, nilable: true, clean: true},
  })
end

require "./ingress/*"
