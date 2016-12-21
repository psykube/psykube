require "yaml"

class Psykube::Kubernetes::PersistentVolumeClaim::Status
  YAML.mapping(
    phase: {type: String},                                   # nilable?
    access_modes: {type: Array(String), key: "accessModes"}, # nilable?
    capacity: {type: Hash(String, String)}                   # nilable?
  )
end
