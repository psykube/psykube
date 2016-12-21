require "yaml"

class Psykube::Manifest::Healthcheck::Tcp
  YAML.mapping(
    port: String | UInt16
  )
end
