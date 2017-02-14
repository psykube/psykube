require "../../../concerns/mapping"

class Psykube::Kubernetes::Shared::VolumeSource::EmptyDir
  Kubernetes.mapping({
    medium: String,
  })
end
