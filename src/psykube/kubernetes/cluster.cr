require "./concerns/resource"

class Psykube::Kubernetes::Cluster
  include Resource
  definition("federation/v1beta1", "Cluster", {
    spec:   Spec?,
    status: {type: Status, nilable: true, clean: true},
  })
end

require "./cluster/*"
