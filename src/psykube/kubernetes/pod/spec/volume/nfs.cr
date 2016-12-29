require "../../../concerns/mapping"

class Psykube::Kubernetes::Pod::Spec::Volume::Nfs
  Kubernetes.mapping({
    server:    String,
    path:      String | Nil,
    read_only: Bool | Nil,
  })
end
