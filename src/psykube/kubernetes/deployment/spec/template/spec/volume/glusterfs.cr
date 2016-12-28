require "../../../../concerns/mapping"

class Psykube::Kubernetes::Deployment::Spec::Template::Spec::Volume::Glusterfs
  Kubernetes.mapping({
    endpoints: String,
    path:      String | Nil,
    read_only: Bool | Nil,
  })
end
