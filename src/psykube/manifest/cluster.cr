class Psykube::Manifest::Cluster
  Manifest.mapping({
    ingress:    Ingress?,
    config_map: {type: Hash(String, String), default: {} of String => String},
    secrets:    {type: Hash(String, String), default: {} of String => String},
    autoscale:  Autoscale?,
  })

  def initialize
    @config_map = {} of String => String
    @secrets = {} of String => String
  end
end

require "./ingress"
require "./autoscale"
