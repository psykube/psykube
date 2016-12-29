require "../../concerns/mapping"

class Psykube::Kubernetes::Deployment::Spec::RollbackTo
  alias MatchLabels = Hash(String, String)

  Kubernetes.mapping({
    revision: UInt32,
  })

  def initialize(@revision : UInt32)
  end
end
