require "../../../concerns/mapping"

class Psykube::Kubernetes::Pod::Spec::Volume::GcePersistentDisk
  Kubernetes.mapping({
    pd_name:   String,
    fs_type:   String,
    partition: UInt16?,
    read_only: Bool?,
  })
end
