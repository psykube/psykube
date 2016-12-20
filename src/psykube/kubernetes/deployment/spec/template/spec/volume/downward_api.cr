require "yaml"

class Psykube::Kubernetes::Deployment::Spec::Template::Spec::Volume::DownwardAPI
  YAML.mapping({
    items:        Array(Item),
    default_mode: {type: UInt16, nilable: true, key: "defaultMode"},
  }, true)
end

require "./downward_api/*"
