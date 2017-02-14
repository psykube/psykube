require "../../../concerns/mapping"

class Psykube::Kubernetes::Shared::VolumeSource::Glusterfs
  Kubernetes.mapping({
    endpoints: String,
    path:      String?,
    read_only: Bool?,
  })
end
