require "../../../../concerns/mapping"

class Psykube::Kubernetes::Deployment::Spec::Template::Spec::Volume::EmptyDir
  Kubernetes.mapping({
    medium: String,
  })
end
