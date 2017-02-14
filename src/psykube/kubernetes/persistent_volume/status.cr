require "../../concerns/mapping"

class Psykube::Kubernetes::PersistentVolume::Status
  Kubernetes.mapping({
    phase:   String?,
    message: String?,
    reason:  String?,
  })
end
