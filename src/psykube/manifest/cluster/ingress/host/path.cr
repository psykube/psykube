require "yaml"

class Psykube::Manifest::Cluster::Ingress::Host::Path
  YAML.mapping(
    port: UInt16
  )
end
