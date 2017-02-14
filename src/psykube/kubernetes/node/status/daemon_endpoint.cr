require "../../concerns/mapping"

class Psykube::Kubernetes::Node::Status::DaemonEndpoint
  Kubernetes.mapping({
    kubelet_endpoint: KubeletEndpoint?,
  })
end

require "./daemon_endpoint/*"
