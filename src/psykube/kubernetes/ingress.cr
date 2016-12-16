require "yaml"
require "./shared/*"

class Psykube::Kubernetes::Ingress
  YAML.mapping(
    kind: String,
    apiVersion: String,
    metadata: {type: Psykube::Kubernetes::Shared::Metadata},
    spec: {type: Psykube::Kubernetes::Ingress::Spec},
    status: {type: Psykube::Kubernetes::Shared::Status, nilable: true, setter: false}
  )

  def initialize
    @kind = "Ingress"
    @apiVersion = "v1"
    @metadata = Psykube::Kubernetes::Shared::Metadata.new
    @spec = Psykube::Kubernetes::Ingress::Spec.new
  end
end

require "./ingress/*"
