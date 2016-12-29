require "../../concerns/mapping"

class Psykube::Kubernetes::Ingress::Spec
  Kubernetes.mapping(
    backend: Psykube::Kubernetes::Ingress::Spec::Backend | Nil,
    tls: Array(Psykube::Kubernetes::Ingress::Spec::Tls) | Nil,
    rules: Array(Psykube::Kubernetes::Ingress::Spec::Rule) | Nil
  )

  def initialize
  end
end

require "./spec/*"
