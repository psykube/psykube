require "yaml"

class Psykube::Kubernetes::Ingress::Spec
  YAML.mapping(
    backend: {type: Psykube::Kubernetes::Ingress::Spec::Backend, nillable: true},  # nillable?
    tls: {type: Psykube::Kubernetes::Ingress::Spec::Tls, nillable: true},          # nillabl?
    rules: {type: Array(Psykube::Kubernetes::Ingress::Spec::Rule), nillable: true} # nillable?
  )
end

require "./spec/*"
