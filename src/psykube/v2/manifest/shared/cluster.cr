class Psykube::V2::Manifest::Shared::Cluster
  getter? initialized : Bool = false

  Macros.mapping({
    replicas:            {type: Int32, optional: true},
    registry_host:       {type: String, optional: true},
    registry_user:       {type: String, optional: true},
    labels:              {type: StringMap, optional: true},
    annotations:         {type: StringMap, optional: true},
    prefix:              {type: String, optional: true},
    suffix:              {type: String, optional: true},
    ingress:             {type: Manifest::Ingress, optional: true},
    context:             {type: String, optional: true},
    namespace:           {type: String, optional: true},
    config_map:          {type: StringMap, default: {} of String => String},
    secrets:             {type: StringMap, default: {} of String => String},
    autoscale:           {type: Manifest::Autoscale, optional: true},
    container_overrides: {type: ContainerOverides, default: ContainerOverides.new},
  })

  def initialize(@context : String? = nil)
    @initialized = true
  end
end

require "./cluster/*"
