require "yaml"

class Psykube::Manifest::Healthcheck::Http
  YAML.mapping(
    path: {type: String, default: "/"},
    port: {type: String | UInt16, default: "default"},
    host: String | Nil,
    scheme: String | Nil,
    headers: {type: Hash(String, String), nilable: true},
  )
end
