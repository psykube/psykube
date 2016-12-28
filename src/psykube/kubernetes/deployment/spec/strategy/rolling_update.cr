require "../../../../concerns/mapping"

class Psykube::Kubernetes::Deployment::Spec::Strategy::RollingUpdate
  Kubernetes.mapping({
    max_unavailable: {type: String, nilable: true},
    max_surge:       {type: String, nilable: true},
  })
end
