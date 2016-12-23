require "yaml"

class Psykube::Manifest::Cluster
  YAML.mapping(
    ingress: Ingress | Nil,
    config_map: {type: Hash(String, String), default: {} of String => String},
    secrets: {type: Hash(String, String), default: {} of String => String},
  )
end
