require "../../../../concerns/mapping"

class Psykube::Kubernetes::Pod::Spec::Volume::ConfigMap::Item
  Kubernetes.mapping({
    key:  String,
    path: String,
    mode: UInt16,
  })
end
