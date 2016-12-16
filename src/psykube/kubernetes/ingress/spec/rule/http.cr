require "yaml"

class Psykube::Kubernetes::Ingress::Spec::Rule::Http
  YAML.mapping(
    paths: {type: Array(Psykube::Kubernetes::Ingress::Spec::Rule::Http::Path), nilable: true}
  )
end

def initialize
  @paths = [] of Psykube::Kubernetes::Ingress::Spec::Rule::Http::Path
end

require "./http/*"
