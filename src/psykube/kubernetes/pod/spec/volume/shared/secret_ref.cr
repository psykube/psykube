require "../../../../concerns/mapping"

class Psykube::Kubernetes::Pod::Spec::Volume::SecretRef
  Kubernetes.mapping({
    name: String,
  })
end
