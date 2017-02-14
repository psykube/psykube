require "./shared/metadata"
require "./concerns/resource"

class Psykube::Kubernetes::Pod
  include Resource
  definition("v1", "Pod", {
    spec:   Spec?,
    status: {type: Status, nilable: true, clean: true},
  })
end

require "./pod/*"
