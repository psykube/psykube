require "yaml"

class Psykube::Manifest::Env::ConfigMap
  YAML.mapping(
    name: String | Nil,
    key: String | Nil
  )
end
