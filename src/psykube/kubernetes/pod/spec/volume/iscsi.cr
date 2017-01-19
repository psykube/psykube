require "../../../concerns/mapping"

class Psykube::Kubernetes::Pod::Spec::Volume::Iscsi
  Kubernetes.mapping({
    target_portal:   String,
    iqn:             String,
    lun:             UInt16,
    iscsi_interface: String,
    fs_type:         String,
    read_only:       Bool?,
  })
end
