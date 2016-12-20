require "yaml"

class Psykube::Kubernetes::Deployment::Spec::Template::Spec::Volume::SecretRef
  YAML.mapping({
    name: String,
  }, true)
end
