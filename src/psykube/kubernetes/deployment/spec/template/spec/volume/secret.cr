require "yaml"

class Psykube::Kubernetes::Deployment::Spec::Template::Spec::Volume::Secret
  YAML.mapping({
    secret_name:  {type: String, key: "secretName"},
    items:        Array(Item),
    default_mode: {type: UInt16, nilable: true, key: "defaultMode"},
  }, true)
end

require "./secret/*"
