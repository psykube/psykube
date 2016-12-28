require "../../concerns/mapping"

class Psykube::Kubernetes::PersistentVolumeClaim::Status
  Kubernetes.mapping(
    phase: String,
    access_modes: Array(String),
    capacity: Hash(String, String)
  )
end
