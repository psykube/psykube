require "../concerns/mapping"
require "../shared/local_object_reference"

class Psykube::Kubernetes::Cluster::Status
  Kubernetes.mapping({
    conditions: Array(Condition)?,
    zones:      Array(String)?,
    region:     String?,
  })
end

require "./status/*"
