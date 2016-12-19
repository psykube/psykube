require "yaml"

class Psykube::Manifest::Cluster::Ingress::Host
  alias PathStrings = Array(String)
  alias PathPortMap = Hash(String, String)

  YAML.mapping(
    tls: Tls | Nil,
    paths: PathStrings | PathPortMap
  )
end

require "./host/*"
