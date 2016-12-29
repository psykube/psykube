require "yaml"
require "./autoscale"

class Psykube::Manifest::Cluster
  YAML.mapping(
    ingress: Ingress | Nil,
    config_map: {type: Hash(String, String), default: {} of String => String},
    secrets: {type: Hash(String, String), default: {} of String => String},
    autoscale: {type: Autoscale, nilable: true}
  )

  def initialize
    @config_map = {} of String => String
    @secrets = {} of String => String
  end
end

require "./ingress"
require "./autoscale"
