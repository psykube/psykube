require "../../concerns/mapping"

class Psykube::Kubernetes::Cluster::Spec::ServerAddressByClientCIDR
  Kubernetes.mapping({
    client_cidr:    {type: String, key: "clientCIDR"},
    server_address: String,
  })
end
