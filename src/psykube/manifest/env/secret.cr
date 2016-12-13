require "yaml"

class Psykube::Manifest::Env::Secret
  YAML.mapping(
    name: String | Nil,
    key: String | Nil
  )
end
