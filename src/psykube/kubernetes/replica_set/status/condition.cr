require "../../concerns/mapping"

class Psykube::Kubernetes::ReplicaSet::Status::Condition
  Kubernetes.mapping({
    last_transition_time: Time?,
    message:              String?,
    reason:               String?,
    status:               String,
    type:                 String,
  })
end
