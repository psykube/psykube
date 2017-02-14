require "../../concerns/mapping"

class Psykube::Kubernetes::Node::Status::Condition
  Kubernetes.mapping({
    last_heartbeat_time:  Time?,
    last_transition_time: Time?,
    message:              String?,
    reason:               String?,
    status:               String,
    type:                 String,
  })
end
