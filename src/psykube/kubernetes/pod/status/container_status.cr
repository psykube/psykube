require "../../concerns/mapping"

class Psykube::Kubernetes::Pod::Status::ContainerStatus
  Kubernetes.mapping({
    name:          {type: String, setter: false},
    state:         {type: State, setter: false},
    lastState:     {type: State, setter: false},
    ready:         {type: Bool, setter: false},
    restart_count: {type: UInt32, setter: false},
    image:         {type: String, setter: false},
    image_id:      {type: String, setter: false, key: "imageID"},
    container_id:  {type: String, setter: false, key: "containerID", nilable: true},
  })
end

require "./container_status/*"
