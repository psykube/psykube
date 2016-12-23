require "yaml"

class Psykube::Manifest::Ingress::Host::Tls
  YAML.mapping(
    secret_name: {type: String, key: "secretName"}
  )
end
