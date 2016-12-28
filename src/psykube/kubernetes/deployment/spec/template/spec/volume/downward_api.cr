require "../../../../concerns/mapping"

class Psykube::Kubernetes::Deployment::Spec::Template::Spec::Volume::DownwardAPI
  Kubernetes.mapping({
    items:        Array(Item),
    default_mode: UInt16 | Nil,
  })
end

require "./downward_api/*"
