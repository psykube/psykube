require "yaml"

class Psykube::Manifest::Ingress::Host::Path
  YAML.mapping(
    port: UInt16
  )
end
