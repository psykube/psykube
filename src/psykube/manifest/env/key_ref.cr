require "yaml"

class Psykube::Manifest::Env::KeyRef
  YAML.mapping(
    name: String,
    key: String
  )
end
