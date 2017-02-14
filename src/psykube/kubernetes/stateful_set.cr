require "./shared/local_object_reference"
require "./shared/object_reference"
require "./concerns/resource"

class Psykube::Kubernetes::StatefulSet
  include Resource
  definition("apps/v1beta1", "StatefulSet", {
    spec:   Spec?,
    status: {type: Status, nilable: true, clean: true},
  })
end

require "./stateful_set/*"
