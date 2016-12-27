require "../../../../concerns/mapping"

class Psykube::Kubernetes::Deployment::Spec::Template::Spec::Volume::GitRepo
  Kubernetes.mapping({
    repository: {type: String},
    revision:   {type: String},
    directory:  {type: UInt16, nilable: true},
  })
end
