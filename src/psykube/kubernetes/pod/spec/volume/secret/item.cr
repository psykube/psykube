require "../../../../concerns/mapping"

class Psykube::Kubernetes::Pod::Spec::Volume::Secret::Item
  Kubernetes.mapping({
    key:   String,
    value: String,
    mode:  UInt16?,
  })
end
