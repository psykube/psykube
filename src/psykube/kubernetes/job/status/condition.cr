require "../../concerns/mapping"

class Psykube::Kubernetes::Job::Status::Condition
  Kubernetes.mapping({
    last_probe_time:      Time?,
    last_transition_time: Time?,
    message:              String?,
    reason:               String?,
    status:               String,
    type:                 String,
  })
end
