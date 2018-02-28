class Psykube::V1::Manifest::Service
  Manifest.mapping({
    type:                        {type: String, default: "ClusterIP", getter: false},
    annotations:                 Hash(String, String)?,
    cluster_ip:                  {type: String, nilable: true, getter: false},
    load_balancer_ip:            String?,
    external_ips:                Array(String)?,
    session_affinity:            String?,
    load_balancer_source_ranges: Array(String)?,
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
