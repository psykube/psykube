require "../../concerns/mapping"

class Psykube::Kubernetes::Ingress::Spec::Rule
  Kubernetes.mapping(
    host: String?,
    http: Psykube::Kubernetes::Ingress::Spec::Rule::Http
  )

  def initialize(host : String, paths : Array(Psykube::Kubernetes::Ingress::Spec::Rule::Http::Path))
    @host = host
    @http = Psykube::Kubernetes::Ingress::Spec::Rule::Http.new(paths)
  end
end

require "./rule/*"
