class Psykube::V2::Manifest::Shared::Cluster
  Macros.mapping({
    labels:              Hash(String, String)?,
    annotations:         Hash(String, String)?,
    prefix:              String?,
    suffix:              String?,
    ingress:             V1::Ingress?,
    context:             String?,
    namespace:           String?,
    config_map:          {type: Hash(String, String), nilable: true, default: {} of String => String},
    secrets:             {type: Hash(String, String), nilable: true, default: {} of String => String},
    autoscale:           V1::Autoscale?,
    container_overrides: {type: ContainerOverides, default: ContainerOverides.new},
  })

  def initialize(@context : String? = nil)
  end

  @config_map = {} of String => String
  @secrets = {} of String => String
end

require "./cluster"
