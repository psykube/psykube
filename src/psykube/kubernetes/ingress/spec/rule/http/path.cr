require "../../../../concerns/mapping"
require "../../backend"

class Psykube::Kubernetes::Ingress::Spec::Rule::Http::Path
  Kubernetes.mapping(
    path: String,
    backend: Psykube::Kubernetes::Ingress::Spec::Backend
  )

  def initialize(path : String, backend_name : String, backend_port : UInt16)
    @path = path
    @backend = Psykube::Kubernetes::Ingress::Spec::Backend.new(backend_name, backend_port)
  end
end
