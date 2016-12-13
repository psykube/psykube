require "yaml"

class Psykube::Manifest::Cluster::Ingress
  YAML.mapping(
    hosts: Hash(String, Host),
  )
end

require "./ingress/*"
