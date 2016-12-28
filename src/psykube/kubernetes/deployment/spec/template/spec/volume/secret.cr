require "../../../../concerns/mapping"

class Psykube::Kubernetes::Deployment::Spec::Template::Spec::Volume::Secret
  Kubernetes.mapping({
    secret_name:  String,
    items:        Array(Item) | Nil,
    default_mode: UInt16 | Nil,
  })
end

require "./secret/*"
