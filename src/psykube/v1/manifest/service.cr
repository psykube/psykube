class Psykube::V1::Manifest::Service
  Macros.mapping({
    type:                        {type: String, default: "ClusterIP", getter: false},
    annotations:                 {type: StringMap, nilable: true},
    cluster_ip:                  {type: String, nilable: true, getter: false},
    load_balancer_ip:            {type: String, nilable: true},
    external_ips:                {type: Array(String), nilable: true},
    session_affinity:            {type: String, nilable: true},
    load_balancer_source_ranges: {type: Array(String), nilable: true},
  })

  def initialize(@type : String = "ClusterIP")
  end

  def cluster_ip
    @type == "Headless" ? "None" : @cluster_ip
  end

  def type
    @type == "Headless" ? "ClusterIP" : @type
  end
end
