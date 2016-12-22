require "yaml"

class Psykube::Kubernetes::PersistentVolumeClaim::Status
  YAML.mapping(
    phase: {type: String},
    access_modes: {type: Array(String), key: "accessModes"},
    capacity: {type: Hash(String, String)}
  )
end
