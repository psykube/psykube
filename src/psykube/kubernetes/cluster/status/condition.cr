require "../../concerns/mapping"

class Psykube::Kubernetes::Cluster::Status::Condition
  Kubernetes.mapping({
    type:                 String,
    status:               String,
    last_probe_time:      Time?,
    last_transition_time: Time?,
    reason:               String?,
    message:              String?,
  })
end
