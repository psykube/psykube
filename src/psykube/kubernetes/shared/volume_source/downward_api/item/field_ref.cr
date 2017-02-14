require "../../../../../concerns/mapping"

class Psykube::Kubernetes::Shared::VolumeSource::DownwardAPI::Item::FieldRef
  Kubernetes.mapping({
    api_version: String,
    field_path:  String,
  })
end
