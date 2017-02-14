require "../../concerns/mapping"

class Psykube::Kubernetes::PodSecurityPolicy::Spec::PortRange
  Kubernetes.mapping({
    min: UInt16,
    max: UInt16,
  })
end
