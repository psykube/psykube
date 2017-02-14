require "../../concerns/mapping"

class Psykube::Kubernetes::ReplicaSet::Status
  Kubernetes.mapping({
    conditions:             {type: Array(Condition), setter: false, nilable: true},
    observed_generation:    Int32?,
    available_replicas:     Int32?,
    replicas:               Int32,
    ready_replicas:         Int32?,
    fully_labeled_replicas: Int32?,
  })
end

require "./status/*"
