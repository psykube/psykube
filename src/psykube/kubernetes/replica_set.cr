require "./shared/metadata"
require "./concerns/resource"

class Psykube::Kubernetes::ReplicaSet
  include Resource
  definition("extensions/v1beta1", "ReplicaSet", {
    spec:   Spec?,
    status: {type: Status, nilable: true, clean: true},
  })
end

require "./replica_set/*"
