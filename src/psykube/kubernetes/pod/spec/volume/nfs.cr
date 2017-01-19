require "../../../concerns/mapping"

class Psykube::Kubernetes::Pod::Spec::Volume::Nfs
  Kubernetes.mapping({
    server:    String,
    path:      String?,
    read_only: Bool?,
  })
end
