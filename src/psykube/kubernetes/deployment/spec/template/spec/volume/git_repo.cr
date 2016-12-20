require "yaml"

class Psykube::Kubernetes::Deployment::Spec::Template::Spec::Volume::GitRepo
  YAML.mapping({
    repository: {type: String},
    revision:   {type: String},
    directory:  {type: UInt16, nilable: true},
  }, true)
end
