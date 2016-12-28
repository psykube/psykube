require "../../../../concerns/mapping"

class Psykube::Kubernetes::Deployment::Spec::Template::Spec::Volume::Nfs
  Kubernetes.mapping({
    server:    String,
    path:      String | Nil,
    read_only: Bool | Nil,
  })
end
