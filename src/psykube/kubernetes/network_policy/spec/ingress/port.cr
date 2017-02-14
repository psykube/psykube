require "../../../shared/selector"
require "../../../concerns/mapping"

class Psykube::Kubernetes::NetworkPolicy::Spec::Ingress::Port
  Kubernetes.mapping({
    port:     UInt16?,
    protocol: String?,
  })
end
