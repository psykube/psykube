require "../../../concerns/mapping"

class Psykube::Kubernetes::Shared::VolumeSource::GcePersistentDisk
  Kubernetes.mapping({
    pd_name:   String,
    fs_type:   String,
    partition: UInt16?,
    read_only: Bool?,
  })
end
