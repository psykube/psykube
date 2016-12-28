require "../../concerns/mapping"

class Psykube::Kubernetes::Pod::Status::Condition
  Kubernetes.mapping({
    type:                 {type: String, nilable: true, setter: false},
    status:               {type: String, nilable: true, setter: false},
    last_probe_time:      {type: String, nilable: true, setter: false},
    last_transition_time: {type: String, nilable: true, setter: false},
    reason:               {type: String, nilable: true, setter: false},
    message:              {type: String, nilable: true, setter: false},
  })
end
