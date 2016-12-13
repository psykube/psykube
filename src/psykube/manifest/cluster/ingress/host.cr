require "yaml"

class Psykube::Manifest::Cluster::Ingress::Host
  YAML.mapping(
    tls: Tls | Nil,
    paths: Array(String) | Hash(String, Path)
  )
end

require "./host/*"
