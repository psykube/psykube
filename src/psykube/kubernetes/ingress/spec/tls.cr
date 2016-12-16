require "yaml"

class Psykube::Kubernetes::Ingress::Spec::Tls
  YAML.mapping(
    hosts: {type: Array(String)},
    secretName: {type: String}
  )
end
