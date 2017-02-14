require "../shared/selector"
require "../concerns/mapping"

class Psykube::Kubernetes::NetworkPolicy::Spec
  Kubernetes.mapping({
    ingress:      Array(Ingress)?,
    pod_selector: Shared::Selector,
  })
end

require "./spec/*"
