require "yaml"

class Psykube::Manifest::Env::FieldRef
  YAML.mapping(
    api_version: String?,
    path: String
  )
end
