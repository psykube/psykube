require "../../../concerns/mapping"

class Psykube::Kubernetes::Shared::VolumeSource::VsphereVolume
  Kubernetes.mapping({
    volume_path: String,
    fs_type:     String,
  })
end
