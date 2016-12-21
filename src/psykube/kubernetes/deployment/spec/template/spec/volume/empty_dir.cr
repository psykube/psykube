require "yaml"

class Psykube::Kubernetes::Deployment::Spec::Template::Spec::Volume::EmptyDir
  YAML.mapping({
    medium: String,
  }, true)
end
