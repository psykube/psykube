class Psykube::V1::Manifest::Service
  Macros.mapping({
    type:                        {type: String, default: "ClusterIP"},
    annotations:                 {type: StringMap, optional: true},
    cluster_ip:                  {type: String, optional: true},
    load_balancer_ip:            {type: String, optional: true},
    external_ips:                {type: Array(String), optional: true},
    session_affinity:            {type: String, optional: true},
    load_balancer_source_ranges: {type: Array(String), optional: true},
    ports:                       {type: Hash(String, Int32), optional: true}
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
