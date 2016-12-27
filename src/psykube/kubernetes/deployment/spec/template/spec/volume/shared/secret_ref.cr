require "../../../../../concerns/mapping"

class Psykube::Kubernetes::Deployment::Spec::Template::Spec::Volume::SecretRef
  Kubernetes.mapping({
    name: String,
  })
end
