require "./concerns/resource"

class Psykube::Kubernetes::LimitRange
  Resource.definition("v1", "LimitRange", {
    spec: Spec?,
  })
end

require "./limit_range/*"
