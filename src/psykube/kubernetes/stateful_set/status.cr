require "../../concerns/mapping"

class Psykube::Kubernetes::StatefulSet::Status
  Kubernetes.mapping({
    observed_generation: Int32?,
    replicas:            Int32,
  })
end
