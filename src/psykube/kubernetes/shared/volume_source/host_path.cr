require "../../../concerns/mapping"

class Psykube::Kubernetes::Shared::VolumeSource::HostPath
  Kubernetes.mapping({
    path: String,
  })
end
