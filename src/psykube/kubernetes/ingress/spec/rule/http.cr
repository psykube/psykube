require "yaml"

class Psykube::Kubernetes::Ingress::Spec::Rule::Http
  YAML.mapping(
    paths: {type: Array(Psykube::Kubernetes::Ingress::Spec::Rule::Http::Path), nilable: true}
  )

  def initialize(paths : Array(Psykube::Kubernetes::Ingress::Spec::Rule::Http::Path))
    @paths = paths
  end
end

require "./http/*"
