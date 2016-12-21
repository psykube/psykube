require "yaml"

class Psykube::Kubernetes::Shared::SecurityContext::SeLinuxOptions
  YAML.mapping({
    level: String,
    user:  String | Nil,
    role:  String | Nil,
    type:  String | Nil,
  }, true)

  def initialize(@level : String)
  end
end
