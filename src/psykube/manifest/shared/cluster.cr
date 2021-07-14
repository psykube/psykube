class Psykube::Manifest::Shared::Cluster
  getter? initialized : Bool = false

  Macros.mapping({
    replicas:            {type: Int32, optional: true},
    registry_host:       {type: String, optional: true},
    registry_user:       {type: String, optional: true},
    labels:              {type: StringableMap, optional: true},
    annotations:         {type: StringableMap, optional: true},
    prefix:              {type: String, optional: true},
    suffix:              {type: String, optional: true},
    ingress:             {type: Manifest::Ingress, optional: true},
    context:             {type: String, optional: true},
    namespace:           {type: String, optional: true},
    config_map:          {type: StringableMap, default: StringableMap.new},
    secrets:             {type: StringableMap | Bool, optional: true},
    autoscale:           {type: Manifest::Autoscale, optional: true},
    container_overrides: {type: ContainerOverides, default: ContainerOverides.new},
    volumes:             {type: VolumeMap, default: VolumeMap.new},
  })

  def initialize(@context : String? = nil)
    @initialized = true
  end
end

require "./cluster/*"
