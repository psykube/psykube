require "../../../concerns/mapping"

class Psykube::Kubernetes::Pod::Spec::Volume::ConfigMap
  Kubernetes.mapping({
    name:        String,
    items:       Array(Item) | Nil,
    defaultMode: UInt16,
  })
end

require "./config_map/*"
