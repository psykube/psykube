require "../../../concerns/mapping"

class Psykube::Kubernetes::Shared::VolumeSource::Nfs
  Kubernetes.mapping({
    server:    String,
    path:      String?,
    read_only: Bool?,
  })
end
