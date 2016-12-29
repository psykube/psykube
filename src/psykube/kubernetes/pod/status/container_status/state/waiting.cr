require "../../../../concerns/mapping"

class Psykube::Kubernetes::Pod::Status::ContainerStatus::Waiting
  Kubernetes.mapping({
    reason:  {type: String, setter: false},
    message: {type: String, setter: false},
  })
end
