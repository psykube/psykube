require "../../../../concerns/mapping"

class Psykube::Kubernetes::Deployment::Spec::Strategy::RollingUpdate
  Kubernetes.mapping({
    max_unavailable: {type: UInt32, nilable: true},
    max_surge:       {type: UInt32, nilable: true},
  })
end
