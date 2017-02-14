require "../../../../concerns/mapping"

class Psykube::Kubernetes::Shared::VolumeSource::ConfigMap::Item
  Kubernetes.mapping({
    key:  String,
    path: String,
    mode: Int32?,
  })
end
