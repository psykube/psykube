require "yaml"

class Psykube::Manifest::Ingress
  YAML.mapping({
    annotations: Hash(String, String) | Nil,
    hosts:       Hash(String, Host) | Nil,
  }, true)

  def initialize
  end
end

require "./ingress/*"
