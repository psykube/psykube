require "../../../concerns/mapping"

class Psykube::Kubernetes::Pod::Spec::Volume::HostPath
  Kubernetes.mapping({
    path: String,
  })
end
