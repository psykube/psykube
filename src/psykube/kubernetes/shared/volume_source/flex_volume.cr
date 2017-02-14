require "../../../concerns/mapping"
require "../../../shared/local_object_reference"

class Psykube::Kubernetes::Shared::VolumeSource::FlexVolume
  Kubernetes.mapping({
    driver:     String,
    fs_type:    String,
    secret_ref: Shared::LocalObjectReference,
    read_only:  Bool?,
    options:    Hash(String, String) | Nil,
  })
end
