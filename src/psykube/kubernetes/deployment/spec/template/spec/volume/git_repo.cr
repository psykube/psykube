require "../../../../concerns/mapping"

class Psykube::Kubernetes::Deployment::Spec::Template::Spec::Volume::GitRepo
  Kubernetes.mapping({
    repository: String,
    revision:   String,
    directory:  UInt16 | Nil,
  })
end
