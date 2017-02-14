require "../concerns/mapping"

class Psykube::Kubernetes::Shared::LocalObjectReference
  Kubernetes.mapping({
    name: String?,
  })
end
