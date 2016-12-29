require "../../../concerns/mapping"

class Psykube::Kubernetes::Pod::Spec::Volume::EmptyDir
  Kubernetes.mapping({
    medium: String,
  })
end
