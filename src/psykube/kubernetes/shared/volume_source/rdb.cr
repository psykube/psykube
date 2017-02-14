require "../../../concerns/mapping"
require "../../../shared/local_object_reference"

class Psykube::Kubernetes::Shared::VolumeSource::Rbd
  Kubernetes.mapping({
    monitors:   Array(String),
    image:      String,
    fs_type:    String,
    pool:       String,
    user:       String,
    keyring:    String,
    secret_ref: Shared::LocalObjectReference,
    read_only:  Bool?,
  })
end
