require "../../concerns/mapping"

class Psykube::Kubernetes::Ingress::Spec
  Kubernetes.mapping(
    backend: Psykube::Kubernetes::Ingress::Spec::Backend?,
    tls: Array(Psykube::Kubernetes::Ingress::Spec::Tls)?,
    rules: Array(Psykube::Kubernetes::Ingress::Spec::Rule)?
  )

  def initialize
  end
end

require "./spec/*"
