require "../../concerns/mapping"

class Psykube::Kubernetes::NetworkPolicy::Spec::Ingress
  Kubernetes.mapping({
    from:  Peer?,
    ports: Array(Port)?,
  })
end

require "./ingress/*"
