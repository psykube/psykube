require "../../../concerns/mapping"

class Psykube::Kubernetes::Pod::Spec::Volume::VsphereVolume
  Kubernetes.mapping({
    volume_path: String,
    fs_type:     String,
  })
end
