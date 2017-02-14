require "../concerns/mapping"
require "../shared/local_object_reference"

class Psykube::Kubernetes::Cluster::Spec
  Kubernetes.mapping({
    server_address_by_client_cidrs: {type: ServerAddressByClientCIDR, key: "serverAddressByClientCIDRs"},
    secret_ref:                     Shared::LocalObjectReference?,
  })
end

require "./spec/*"
