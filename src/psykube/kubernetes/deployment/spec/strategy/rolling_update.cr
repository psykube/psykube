require "../../../../concerns/mapping"

class Psykube::Kubernetes::Deployment::Spec::Strategy::RollingUpdate
  Kubernetes.mapping({
    max_unavailable: {type: UInt32 | String, nilable: true},
    max_surge:       {type: UInt32 | String, nilable: true},
  })

  def initialize(@max_unavailable : UInt32 | String, @max_surge : UInt32 | String)
  end
end
