require "../../../concerns/mapping"

class Psykube::Kubernetes::Node::Status::Image
  Kubernetes.mapping({
    names:      Array(String),
    size_bytes: Int64?,
  })
end
