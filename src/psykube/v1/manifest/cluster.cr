class Psykube::V1::Manifest::Cluster
  getter? initialized : Bool = false

  Macros.mapping({
    image_tag:     {type: String, optional: true},
    registry_host: {type: String, optional: true},
    registry_user: {type: String, optional: true},
    labels:        {type: StringMap, optional: true},
    annotations:   {type: StringMap, optional: true},
    build_args:    {type: StringMap, default: StringMap.new},
    prefix:        {type: String, optional: true},
    suffix:        {type: String, optional: true},
    ingress:       {type: Ingress, optional: true},
    context:       {type: String, optional: true},
    namespace:     {type: String, optional: true},
    config_map:    {type: StringMap, default: {} of String => String},
    secrets:       {type: StringMap, default: {} of String => String},
    autoscale:     {type: Autoscale, optional: true},
  })

  def initialize(@context : String? = nil)
    @initialized = true
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
