require "../../concerns/mapping"

class Psykube::Kubernetes::PersistentVolumeClaim::Status
  Kubernetes.mapping(
    phase: {type: String},
    access_modes: {type: Array(String), key: "accessModes"},
    capacity: {type: Hash(String, String)}
  )
end
