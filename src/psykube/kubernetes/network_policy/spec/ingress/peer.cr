require "../../../shared/selector"
require "../../../concerns/mapping"

class Psykube::Kubernetes::NetworkPolicy::Spec::Ingress::Peer
  Kubernetes.mapping({
    namespace_selector: Shared::Selector,
    pod_selector:       Shared::Selector,
  })
end
