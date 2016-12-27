require "../../../../concerns/mapping"

class Psykube::Kubernetes::Deployment::Spec::Template::Spec::Volume::VsphereVolume
  Kubernetes.mapping({
    volume_path: {type: String, key: "volumePath"},
    fs_type:     {type: String, key: "fsType"},
  })
end
