require "../../concerns/mapping"

class Psykube::Kubernetes::Shared::SecurityContext::Capabilities
  Kubernetes.mapping({
    add:    Array(String)?,
    remove: Array(String)?,
  })
end
