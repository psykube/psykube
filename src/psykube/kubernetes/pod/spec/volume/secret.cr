require "../../../concerns/mapping"

class Psykube::Kubernetes::Pod::Spec::Volume::Secret
  Kubernetes.mapping({
    secret_name:  String,
    items:        Array(Item)?,
    default_mode: UInt16?,
  })
end

require "./secret/*"
