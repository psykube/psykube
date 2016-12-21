require "yaml"

class Psykube::Manifest::Volume::Claim
  YAML.mapping(
    size: String,
    storage_class: String | Nil,
    access_modes: {type: Array(String), default: ["ReadWriteOnce"]},
    read_only: Bool | Nil
  )
end
