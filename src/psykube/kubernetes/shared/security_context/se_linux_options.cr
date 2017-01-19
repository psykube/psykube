require "../../concerns/mapping"

class Psykube::Kubernetes::Shared::SecurityContext::SeLinuxOptions
  Kubernetes.mapping({
    level: String,
    user:  String?,
    role:  String?,
    type:  String?,
  })

  def initialize(@level : String)
  end
end
