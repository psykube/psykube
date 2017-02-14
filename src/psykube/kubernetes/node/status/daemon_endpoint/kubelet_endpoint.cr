require "../../../concerns/mapping"

class Psykube::Kubernetes::Node::Status::DaemonEndpoint::KubeletEndpoint
  Kubernetes.mapping({
    port: Int32,
  })
end
