require "../../../../concerns/mapping"

class Psykube::Kubernetes::Deployment::Spec::Strategy::RollingUpdate
  Kubernetes.mapping({
    max_unavailable: {type: UInt32 | Manifest::Percentage, nilable: true},
    max_surge:       {type: UInt32 | Manifest::Percentage, nilable: true},
  })

  def initialize(@max_unavailable : UInt32 | Manifest::Percentage, @max_surge : UInt32 | Manifest::Percentage)
  end
end
