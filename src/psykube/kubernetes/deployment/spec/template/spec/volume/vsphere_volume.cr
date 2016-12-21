require "yaml"

class Psykube::Kubernetes::Deployment::Spec::Template::Spec::Volume::VsphereVolume
  YAML.mapping({
    volume_path: {type: String, key: "volumePath"},
    fs_type:     {type: String, key: "fsType"},
  }, true)
end
