require "yaml"

class Psykube::Manifest::Env
  YAML.mapping(
    config_map: String | KeyRef | Nil,
    secret: String | KeyRef | Nil
  )
end

require "./env/*"
