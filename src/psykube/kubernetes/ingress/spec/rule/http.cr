require "../../../concerns/mapping"

class Psykube::Kubernetes::Ingress::Spec::Rule::Http
  Kubernetes.mapping(
    paths: Array(Psykube::Kubernetes::Ingress::Spec::Rule::Http::Path) | Nil
  )

  def initialize(paths : Array(Psykube::Kubernetes::Ingress::Spec::Rule::Http::Path))
    @paths = paths
  end
end

require "./http/*"
