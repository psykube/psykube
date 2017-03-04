class Psykube::Manifest::Cluster
  Manifest.mapping({
    labels:      Hash(String, String)?,
    annotations: Hash(String, String)?,
    ingress:     Ingress?,
    context:     String?,
    namespace:   String?,
    config_map:  {type: Hash(String, String), nilable: true, getter: false},
    secrets:     {type: Hash(String, String), nilable: true, getter: false},
    autoscale:   Autoscale?,
  })

  def initialize(@context : String? = nil)
  end

  def config_map
    @config_map || {} of String => String
  end

  def secrets
    @secrets || {} of String => String
  end
end

require "./ingress"
require "./autoscale"
