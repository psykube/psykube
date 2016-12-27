require "../../../../../concerns/mapping"

class Psykube::Kubernetes::Deployment::Spec::Template::Spec::Volume::Secret::Item
  Kubernetes.mapping({
    key:   String,
    value: String,
    mode:  UInt16 | Nil,
  })
end
