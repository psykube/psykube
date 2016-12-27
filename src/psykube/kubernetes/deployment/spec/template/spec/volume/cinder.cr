require "../../../../concerns/mapping"

class Psykube::Kubernetes::Deployment::Spec::Template::Spec::Volume::Cinder
  Kubernetes.mapping({
    volume_id: {type: String, key: "volumeID"},
    fs_type:   {type: String, key: "fsType"},
    read_only: {type: Bool, nilable: true, key: "readOnly"},
  })
end
