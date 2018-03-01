class Psykube::V2::Manifest::Shared::Cluster
  Macros.mapping({
    registry_host:       {type: String, nilable: true},
    registry_user:       {type: String, nilable: true},
    labels:              {type: StringMap, nilable: true},
    annotations:         {type: StringMap, nilable: true},
    prefix:              {type: String, nilable: true},
    suffix:              {type: String, nilable: true},
    ingress:             {type: V1::Manifest::Ingress, nilable: true},
    context:             {type: String, nilable: true},
    namespace:           {type: String, nilable: true},
    config_map:          {type: StringMap, default: {} of String => String},
    secrets:             {type: StringMap, default: {} of String => String},
    autoscale:           {type: V1::Manifest::Autoscale, nilable: true},
    container_overrides: {type: ContainerOverides, default: ContainerOverides.new},
  })

  def initialize(@context : String? = nil)
  end
end

require "./cluster/*"
