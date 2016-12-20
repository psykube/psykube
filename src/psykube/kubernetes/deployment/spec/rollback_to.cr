require "yaml"

class Psykube::Kubernetes::Deployment::Spec::RollbackTo
  alias MatchLabels = Hash(String, String)

  YAML.mapping({
    revision: UInt32,
  }, true)

  def initialize(@revision : UInt32)
  end
end
