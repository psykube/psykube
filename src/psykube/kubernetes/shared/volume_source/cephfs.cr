require "../../../concerns/mapping"
require "../../../shared/local_object_reference"

class Psykube::Kubernetes::Shared::VolumeSource::Cephfs
  Kubernetes.mapping({
    monitors:    Array(String),
    path:        String,
    user:        String,
    keyring:     String,
    secret_file: String,
    secret_ref:  Shared::LocalObjectReference,
    read_only:   Bool?,
  })
end
