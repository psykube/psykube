require "yaml"

class Psykube::Kubernetes::Deployment::Spec::Template::Spec::Volume::ConfigMap
  YAML.mapping({
    name:        String,
    items:       Array(Item),
    defaultMode: UInt16,
  }, true)
end

require "./config_map/*"
