require "../../../../concerns/mapping"

class Psykube::Kubernetes::Deployment::Spec::Template::Spec::Volume::ConfigMap
  Kubernetes.mapping({
    name:        String,
    items:       Array(Item),
    defaultMode: UInt16,
  })
end

require "./config_map/*"
