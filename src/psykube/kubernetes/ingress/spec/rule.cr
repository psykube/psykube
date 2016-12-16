require "yaml"

class Psykube::Kubernetes::Ingress::Spec::Rule
  YAML.mapping(
    host: {type: String, nilable: true},
    http: {type: Psykube::Kubernetes::Ingress::Spec::Rule::Http}
  )

  def initialize
    @http = Psykube::Kubernetes::Ingress::Spec::Rule::Http.new
  end
end

require "./rule/*"
