require "yaml"

class Psykube::Kubernetes::Deployment::Spec::Template::Spec::Volume::Secret::Item
  YAML.mapping({
    key:   String,
    value: String,
    mode:  UInt16 | Nil,
  }, true)
end
