require "../../concerns/mapping"

class Psykube::Kubernetes::Service::Spec
  Kubernetes.mapping(
    ports: {type: Array(Psykube::Kubernetes::Service::Spec::Port), setter: false},
    selector: {type: Hash(String, String), default: {} of String => String},
    clusterIP: {type: String, nilable: true, setter: false},
    type: {type: String, nilable: true},
    externalIPs: {type: Array(String), nilable: true, setter: false},
    deprecatedPublicIPs: {type: Array(String), nilable: true, setter: false},
    sessionAffinity: {type: String, nilable: true},
    loadBalancerIP: {type: String, nilable: true, setter: false},
    loadBalancerSourceRanges: {type: Array(String), nilable: true},
    externalName: {type: String, nilable: true},
  )

  def initialize
    @ports = [] of Psykube::Kubernetes::Service::Spec::Port
    @selector = {} of String => String
  end
end

require "./spec/*"
