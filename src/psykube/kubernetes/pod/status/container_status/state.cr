require "../../../concerns/mapping"

class Psykube::Kubernetes::Pod::Status::ContainerStatus::State
  Kubernetes.mapping({
    waiting:    {type: Waiting, setter: false, nilable: true},
    running:    {type: Running, setter: false, nilable: true},
    terminated: {type: Terminated, setter: false, nilable: true},
  })
end

require "./state/*"
