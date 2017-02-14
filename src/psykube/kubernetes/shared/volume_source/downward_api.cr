require "../../../concerns/mapping"

class Psykube::Kubernetes::Shared::VolumeSource::DownwardAPI
  Kubernetes.mapping({
    items:        Array(Item),
    default_mode: Int32?,
  })
end

require "./downward_api/*"
