require "./shared/metadata"
require "./concerns/resource"

class Psykube::Kubernetes::ReplicationController
  include Resource
  definition("v1", "ReplicationController", {
    spec:   Spec?,
    status: {type: Status, nilable: true, clean: true},
  })
end

require "./replication_controller/*"
