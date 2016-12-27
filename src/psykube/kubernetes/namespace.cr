require "./concerns/resource"
require "./shared/metadata"

class Psykube::Kubernetes::Namespace
  Resource.definition("v1", "Namespace", {
    spec:   {type: Spec, nilable: true},
    status: {type: Status, nilable: true},
  })
end

require "./namespace/*"
