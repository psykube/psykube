require "../../../concerns/mapping"

class Psykube::Kubernetes::Pod::Spec::Volume::DownwardAPI
  Kubernetes.mapping({
    items:        Array(Item),
    default_mode: UInt16 | Nil,
  })
end

require "./downward_api/*"
