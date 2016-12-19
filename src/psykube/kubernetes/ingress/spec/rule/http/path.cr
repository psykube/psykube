require "yaml"
require "../../backend"

class Psykube::Kubernetes::Ingress::Spec::Rule::Http::Path
  YAML.mapping(
    path: {type: String},
    backend: {type: Psykube::Kubernetes::Ingress::Spec::Backend}
  )

  def initialize(path : String, backend_name : String, backend_port : UInt16)
    @path = path
    @backend = Psykube::Kubernetes::Ingress::Spec::Backend.new(backend_name, backend_port)
  end
end
