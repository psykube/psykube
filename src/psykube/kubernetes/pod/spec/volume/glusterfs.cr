require "../../../concerns/mapping"

class Psykube::Kubernetes::Pod::Spec::Volume::Glusterfs
  Kubernetes.mapping({
    endpoints: String,
    path:      String?,
    read_only: Bool?,
  })
end
