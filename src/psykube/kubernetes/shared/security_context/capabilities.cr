require "../../concerns/mapping"

class Psykube::Kubernetes::Shared::SecurityContext::Capabilities
  Kubernetes.mapping({
    add:    Array(Hash(String, String)) | Nil,
    remove: Array(Hash(String, String)) | Nil,
  })
end
