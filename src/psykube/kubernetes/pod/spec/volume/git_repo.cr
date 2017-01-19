require "../../../concerns/mapping"

class Psykube::Kubernetes::Pod::Spec::Volume::GitRepo
  Kubernetes.mapping({
    repository: String,
    revision:   String,
    directory:  UInt16?,
  })
end
