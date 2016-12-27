require "../../../../concerns/mapping"

class Psykube::Kubernetes::Deployment::Spec::Template::Spec::Volume::Fc
  Kubernetes.mapping({
    target_wwns: {type: Array(String), key: "targetWWNs"},
    lun:         UInt16,
    fs_type:     {type: String, key: "fsType"},
    read_only:   {type: Bool, nilable: true, key: "readOnly"},
  })
end
