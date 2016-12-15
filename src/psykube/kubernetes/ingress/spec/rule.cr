require "yaml"

class Psykube::Kubernetes::Ingress::Spec::Rule
  YAML.mapping(
    host: {type: String} #nillable?
    http: {type: Psykube::Kubernetes::Ingress::Spec::Rule::Http} #nillable?
  )

  def initialize
    @host = ""
    @http = Psykube::Kubernetes::Ingress::Spec::Rule::Http.new
  end
end

require "./rule/*"
