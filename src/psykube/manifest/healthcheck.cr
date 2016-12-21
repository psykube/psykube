require "yaml"

class Psykube::Manifest::Healthcheck
  YAML.mapping(
    readiness: {type: Bool, default: true},
    http: {type: Http, nilable: true},
    tcp: {type: Tcp, nilable: true},
    exec: {type: Exec, nilable: true}
  )
end

def initialize
  @readiness = true
end

require "./healthcheck/*"
