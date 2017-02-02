require "../../../../concerns/mapping"

class Psykube::Kubernetes::Deployment::Spec::Strategy::RollingUpdate
  Kubernetes.mapping({
    max_unavailable: {type: UInt32, nilable: true},
    max_surge:       {type: UInt32, nilable: true},
  })

  def initialize(@max_unavailable : UInt32, @max_surge : UInt32)
  end
end
