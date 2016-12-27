require "../../concerns/mapping"

class Psykube::Kubernetes::Namespace::Status
  Kubernetes.mapping(
    phase: String
  )
end
