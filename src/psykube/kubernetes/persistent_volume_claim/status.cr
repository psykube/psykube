require "../../concerns/mapping"

class Psykube::Kubernetes::PersistentVolumeClaim::Status
  Kubernetes.mapping(
    phase: String,
    access_modes: Array(String) | Nil,
    capacity: Hash(String, String) | Nil
  )
end
