require "yaml"

class Psykube::Manifest::Cluster::Ingress::Host::Tls
  YAML.mapping(
    acme: {type: Bool, default: false}
  )
end
