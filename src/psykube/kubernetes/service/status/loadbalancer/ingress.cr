require "yaml"

class Psykube::Kubernetes::Service::Status::LoadBalancer::Ingress
  YAML.mapping(
    ip: {type: String, setter: false},
    hostname: {type: String, setter: false}
  )
end
