require "yaml"

class Psykube::Manifest::Cluster
  YAML.mapping(
    ingress: Ingress | Nil,
    configMap: Hash(String, String) | Nil,
    secrets: Hash(String, String) | Nil,
  )
end

require "./cluster/*"
