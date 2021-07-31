class Psykube::Manifest::Service
  Macros.mapping({
    type:                        {type: String, default: "ClusterIP"},
    annotations:                 {type: StringableMap, optional: true},
    cluster_ip:                  {type: String, optional: true},
    load_balancer_ip:            {type: String, optional: true},
    external_ips:                {type: Array(String), optional: true},
    session_affinity:            {type: String, optional: true},
    load_balancer_source_ranges: {type: Array(String), optional: true},
    ports:                       {type: Hash(String, Int32 | String) | Array(Int32 | String | Pyrite::Api::Core::V1::ServicePort), optional: true},
  })

  def initialize(type : String = "ClusterIP")
    case type
    when "Headless"
      @type = "ClusterIP"
      @cluster_ip = "None"
    else
      @type = type
    end
  end
end
