require "../../../concerns/mapping"

class Psykube::Kubernetes::Pod::Spec::Volume::Glusterfs
  Kubernetes.mapping({
    endpoints: String,
    path:      String | Nil,
    read_only: Bool | Nil,
  })
end
