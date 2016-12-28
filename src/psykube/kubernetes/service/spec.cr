require "../../concerns/mapping"

class Psykube::Kubernetes::Service::Spec
  Kubernetes.mapping(
    ports: {type: Array(Psykube::Kubernetes::Service::Spec::Port), setter: false, default: [] of Port},
    selector: {type: Hash(String, String), default: {} of String => String},
    cluster_ip: {type: String, nilable: true, setter: false, key: "clusterIP", clean: true},
    type: String | Nil,
    external_ips: {type: Array(String), nilable: true, setter: false, key: "externalIPs"},
    deprecated_public_ips: {type: Array(String), nilable: true, setter: false, key: "deprecatedPublicIPs"},
    session_affinity: String | Nil,
    load_balancer_ip: {type: String, nilable: true, setter: false, key: "loadBalancerIP"},
    load_balancer_source_ranges: Array(String) | Nil,
    external_name: Array(String) | Nil,
  )
end

require "./spec/*"
