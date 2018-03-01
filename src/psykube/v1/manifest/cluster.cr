class Psykube::V1::Manifest::Cluster
  Macros.mapping({
    image_tag:     {type: String, nilable: true},
    registry_host: {type: String, nilable: true},
    registry_user: {type: String, nilable: true},
    labels:        {type: StringMap, nilable: true},
    annotations:   {type: StringMap, nilable: true},
    build_args:    {type: StringMap, default: StringMap.new},
    prefix:        {type: String, nilable: true},
    suffix:        {type: String, nilable: true},
    ingress:       {type: Ingress, nilable: true},
    context:       {type: String, nilable: true},
    namespace:     {type: String, nilable: true},
    config_map:    {type: StringMap, default: {} of String => String},
    secrets:       {type: StringMap, default: {} of String => String},
    autoscale:     {type: Autoscale, nilable: true},
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
