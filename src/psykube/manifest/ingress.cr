require "yaml"

class Psykube::Manifest::Ingress
  YAML.mapping(
    tls: Tls,
  )
end

require "./ingress/*"
