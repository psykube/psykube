require "./concerns/resource"
require "./shared/metadata"

class Psykube::Kubernetes::Namespace
  Resource.definition("v1", "Namespace", {
    spec:   Spec | Nil,
    status: Status | Nil,
  })
end

require "./namespace/*"
