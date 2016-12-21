require "yaml"

class Psykube::Kubernetes::Deployment::Spec::Template::Spec::Volume::HostPath
  YAML.mapping({
    path: String,
  }, true)
end
