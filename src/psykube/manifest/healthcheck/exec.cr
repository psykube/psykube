require "yaml"

class Psykube::Manifest::Healthcheck::Exec
  YAML.mapping({
    command: String | Array(String),
  }, true)
end
