require "yaml"

class Psykube::Manifest::Ingress::Tls
  YAML.mapping(
    acme: Bool | Nil,
  )
end
