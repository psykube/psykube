require "./concerns/resource"

class Psykube::Kubernetes::Namespace
  include Resource
  definition("v1", "Namespace", {
    spec:   Spec?,
    status: {type: Status, nilable: true, clean: true},
  })
end

require "./namespace/*"
