require "../../../../concerns/mapping"

class Psykube::Kubernetes::Shared::VolumeSource::Secret::Item
  Kubernetes.mapping({
    key:   String,
    value: String,
    mode:  Int32?,
  })
end
