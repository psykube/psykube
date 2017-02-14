require "./concerns/resource"

class Psykube::Kubernetes::Node
  include Resource
  definition("v1", "Node", {
    spec:   Spec?,
    status: {type: Status, nilable: true, clean: true},
  })
end

require "./node/*"
