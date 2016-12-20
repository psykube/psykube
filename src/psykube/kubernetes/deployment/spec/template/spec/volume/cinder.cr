require "yaml"

class Psykube::Kubernetes::Deployment::Spec::Template::Spec::Volume::Cinder
  YAML.mapping({
    volume_id: {type: String, key: "volumeID"},
    fs_type:   {type: String, key: "fsType"},
    read_only: {type: Bool, nilable: true, key: "readOnly"},
  }, true)
end
