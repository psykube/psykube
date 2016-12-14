require "yaml"

class Psykube::Kubernetes::Service::Status::LoadBalancer
  YAML.mapping(
    ingress: {type: Array(Psykube::Kubernetes::Service::Status::LoadBalancer::Ingress), setter: false}
  )
end

require "./loadbalancer/*"
