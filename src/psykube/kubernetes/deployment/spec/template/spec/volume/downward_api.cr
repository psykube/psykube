require "../../../../concerns/mapping"

class Psykube::Kubernetes::Deployment::Spec::Template::Spec::Volume::DownwardAPI
  Kubernetes.mapping({
    items:        Array(Item),
    default_mode: {type: UInt16, nilable: true, key: "defaultMode"},
  })
end

require "./downward_api/*"
