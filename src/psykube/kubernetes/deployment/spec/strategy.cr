require "../../concerns/mapping"

class Psykube::Kubernetes::Deployment::Spec::Strategy
  Kubernetes.mapping({
    type:           String | Nil,
    rolling_update: RollingUpdate | Nil,
  })
end

require "./strategy/*"
