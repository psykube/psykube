require "../../../../concerns/mapping"

class Psykube::Kubernetes::Deployment::Spec::Template::Spec::Volume::Fc
  Kubernetes.mapping({
    target_wwns: {type: Array(String), key: "targetWWNs"},
    lun:         UInt16,
    fs_type:     String,
    read_only:   Bool | Nil,
  })
end
