require "../../concerns/mapping"

class Psykube::Kubernetes::Deployment::Spec::Strategy
  Kubernetes.mapping({
    type:           String?,
    rolling_update: RollingUpdate?,
  })
end

require "./strategy/*"
