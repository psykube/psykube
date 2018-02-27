class Psykube::Manifest::V2::Shared::Cluster
  Manifest.mapping({
    labels:      Hash(String, String)?,
    annotations: Hash(String, String)?,
    prefix:      String?,
    suffix:      String?,
    ingress:     V1::Ingress?,
    context:     String?,
    namespace:   String?,
    config_map:  {type: Hash(String, String), nilable: true, default: {} of String => String},
    secrets:     {type: Hash(String, String), nilable: true, default: {} of String => String},
    autoscale:   V1::Autoscale?,
  })

  def initialize(@context : String? = nil)
  end

  @config_map = {} of String => String
  @secrets = {} of String => String
end
