require "yaml"

class Psykube::Manifest::Env
  YAML.mapping(
    configMap: String | ConfigMap | Nil,
    secret: String | Secret | Nil
  )
end

require "./env/*"
