require "../../../../concerns/mapping"

class Psykube::Kubernetes::Deployment::Spec::Template::Spec::Volume::Quobyte
  Kubernetes.mapping({
    registry:  String,
    volume:    String,
    read_only: Bool | Nil,
    user:      String,
    group:     String,
  })
end
