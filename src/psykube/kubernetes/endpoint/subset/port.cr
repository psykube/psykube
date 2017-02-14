require "../../concerns/mapping"

class Psykube::Kubernetes::Endpoint::Subset::Port
  Kubernetes.mapping({
    name:     String?,
    port:     UInt16,
    protocol: String?,
  })
end
