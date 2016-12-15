require "yaml"

class Psykube::Kubernetes::Ingress::Spec::Tls
  YAML.mapping(
    hosts: {type: Array(String), nillable: true}, # nillable?
    secretName: {type: String, nillable: true}    # nillable?
  )
end
