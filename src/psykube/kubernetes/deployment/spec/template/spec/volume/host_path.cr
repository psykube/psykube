require "../../../../concerns/mapping"

class Psykube::Kubernetes::Deployment::Spec::Template::Spec::Volume::HostPath
  Kubernetes.mapping({
    path: String,
  })
end
