require "yaml"

class Psykube::Manifest::Env::ResourceFieldRef
  YAML.mapping(
    resource: String,
    container: String?,
    divisor: String?
  )
end
