require "../../concerns/mapping"

class Psykube::Kubernetes::Shared::SecurityContext::SeLinuxOptions
  Kubernetes.mapping({
    level: String,
    user:  String | Nil,
    role:  String | Nil,
    type:  String | Nil,
  })

  def initialize(@level : String)
  end
end
