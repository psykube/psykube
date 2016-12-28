require "../../../../concerns/mapping"

class Psykube::Kubernetes::Deployment::Spec::Template::Spec::Volume::VsphereVolume
  Kubernetes.mapping({
    volume_path: String,
    fs_type:     String,
  })
end
