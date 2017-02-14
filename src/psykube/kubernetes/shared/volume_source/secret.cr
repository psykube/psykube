require "../../../concerns/mapping"
require "../../../shared/key_to_path"

class Psykube::Kubernetes::Shared::VolumeSource::Secret
  Kubernetes.mapping({
    secret_name:  String,
    items:        Array(Shared::KeyToPath)?,
    default_mode: Int32?,
  })
end
