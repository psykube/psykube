require "../concerns/mapping"

class Psykube::Kubernetes::LimitRange::Spec
  Kubernetes.mapping({
    limits: Array(Item),
  })
end

require "./spec/*"
