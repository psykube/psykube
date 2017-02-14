require "../../concerns/mapping"

class Psykube::Kubernetes::Node::Status::AttachedVolume
  Kubernetes.mapping({
    address: String,
    type:    String,
  })
end
