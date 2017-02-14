require "../../concerns/mapping"
require "../../shared/object_reference"

class Psykube::Kubernetes::Endpoint::Subset::Address
  Kubernetes.mapping({
    hostname:   String?,
    ip:         String,
    node_name:  String?,
    target_ref: Shared::ObjectReference?,
  })
end
