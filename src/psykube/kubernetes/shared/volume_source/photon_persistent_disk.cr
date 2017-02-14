require "../../../concerns/mapping"
require "../../../shared/key_to_path"

class Psykube::Kubernetes::Shared::VolumeSource::PhotonPersistentDisk
  Kubernetes.mapping({
    fs_type: String?,
    pd_id:   {type: String, key: "pdID"},
  })
end
