require "../../../../../concerns/mapping"

class Psykube::Kubernetes::Shared::VolumeSource::DownwardAPI::Item::ResourceFieldRef
  Kubernetes.mapping({
    container_name: String,
    resource:       String,
    divisor:        String,
  })
end
