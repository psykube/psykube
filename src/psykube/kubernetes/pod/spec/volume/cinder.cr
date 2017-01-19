require "../../../concerns/mapping"

class Psykube::Kubernetes::Pod::Spec::Volume::Cinder
  Kubernetes.mapping({
    volume_id: {type: String, key: "volumeID"},
    fs_type:   String,
    read_only: Bool?,
  })
end
