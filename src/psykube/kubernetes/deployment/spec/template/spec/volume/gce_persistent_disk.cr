require "../../../../concerns/mapping"

class Psykube::Kubernetes::Deployment::Spec::Template::Spec::Volume::GcePersistentDisk
  Kubernetes.mapping({
    pd_name:   String,
    fs_type:   String,
    partition: UInt16 | Nil,
    read_only: Bool | Nil,
  })
end
