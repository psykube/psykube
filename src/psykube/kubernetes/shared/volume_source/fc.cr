require "../../../concerns/mapping"

class Psykube::Kubernetes::Shared::VolumeSource::Fc
  Kubernetes.mapping({
    target_wwns: {type: Array(String), key: "targetWWNs"},
    lun:         UInt16,
    fs_type:     String,
    read_only:   Bool?,
  })
end
