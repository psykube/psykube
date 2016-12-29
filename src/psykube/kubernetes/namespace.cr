require "./concerns/resource"
require "./shared/metadata"

class Psykube::Kubernetes::Namespace
  Resource.definition("v1", "Namespace", {
    spec:   Spec | Nil,
    status: {type: Status, nilable: true, clean: true, setter: false},
  })
end

require "./namespace/*"
