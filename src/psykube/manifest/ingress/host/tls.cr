require "yaml"

class Psykube::Manifest::Ingress::Host::Tls
  YAML.mapping(
    secret_name: String
  )
end
