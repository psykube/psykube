require "../../concerns/mapping"

class Psykube::Kubernetes::StatefulSet::Status
  Kubernetes.mapping({
    observed_generation: Int32?,
    current_replicas:     Int32?,
    ready_replicas:     Int32?,
    updated_replicas:     Int32?,
    current_revision:   String?,
    updateRevision: String?,
    replicas:            Int32,
  })
end
