require "../../../../concerns/mapping"

class Psykube::Kubernetes::Pod::Status::ContainerStatus::Running
  Kubernetes.mapping({
    started_at: {type: String, setter: false},
  })
end
