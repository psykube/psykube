require "yaml"

class Psykube::Kubernetes::Ingress::Spec::Tls
  YAML.mapping(
    hosts: {type: Array(String)}, # nillable?
    secretName: {type: String}    # nillable?
  )
end
