require "../../concerns/mapping"

class Psykube::Kubernetes::Namespace::Spec
  Kubernetes.mapping(
    finalizers: Array(String)
  )
end
