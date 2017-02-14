require "../../../concerns/mapping"

class Psykube::Kubernetes::Shared::VolumeSource::GitRepo
  Kubernetes.mapping({
    repository: String,
    revision:   String,
    directory:  UInt16?,
  })
end
