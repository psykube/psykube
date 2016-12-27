require "../../concerns/mapping"

class Psykube::Kubernetes::Ingress::Spec
  Kubernetes.mapping(
    backend: {type: Psykube::Kubernetes::Ingress::Spec::Backend, nilable: true},
    tls: {type: Array(Psykube::Kubernetes::Ingress::Spec::Tls), nilable: true},
    rules: {type: Array(Psykube::Kubernetes::Ingress::Spec::Rule), nilable: true}
  )

  def initialize
  end
end

require "./spec/*"
