require "./concerns/resource"
require "./shared/metadata"

class Psykube::Kubernetes::Namespace
  include Psykube::Kubernetes::Resource
  definition("v1", "Namespace", {
    spec:   Spec?,
    status: {type: Status, nilable: true, clean: true, setter: false},
  })
end

require "./namespace/*"
