require "yaml"
require "./shared/*"

class Psykube::Kubernetes::Ingress
  YAML.mapping(
    kind: String,
    apiVersion: String,
    metadata: {type: Shared::Metadata},
    spec: {type: Psykube::Kubernetes::Ingress::Spec},
    status: {type: Shared::Status, nilable: true, setter: false}
  )

  def initialize(name : String)
    @kind = "Ingress"
    @apiVersion = "v1"
    @metadata = Shared::Metadata.new(name)
    @spec = Psykube::Kubernetes::Ingress::Spec.new
  end
end

require "./ingress/*"
