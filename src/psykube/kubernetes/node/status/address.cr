require "../../concerns/mapping"

class Psykube::Kubernetes::Node::Status::Address
  Kubernetes.mapping({
    address: String,
    type:    String,
  })
end
