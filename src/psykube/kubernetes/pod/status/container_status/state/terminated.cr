require "../../../../concerns/mapping"

class Psykube::Kubernetes::Pod::Status::ContainerStatus::Terminated
  Kubernetes.mapping({
    exit_code:    {type: UInt16, setter: false},
    signal:       {type: UInt16, setter: false, nilable: true},
    reason:       {type: String, setter: false},
    message:      {type: String, setter: false, nilable: true},
    started_at:   {type: String, setter: false},
    finished_at:  {type: String, setter: false},
    container_id: {type: String, setter: false, key: "containerID"},
  })
end
