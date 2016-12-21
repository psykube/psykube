require "yaml"
require "./shared/metadata"

class Psykube::Kubernetes::Deployment
  YAML.mapping(
    kind: {type: String, setter: false, default: "Deployment"},
    api_version: {type: String, key: "apiVersion", default: "extensions/v1beta1"},
    metadata: {type: Psykube::Kubernetes::Shared::Metadata},
    spec: {type: Spec},
    status: {type: Status, nilable: true, setter: false}
  )

  def initialize(name : String)
    @kind = "Deployment"
    @api_version = "extensions/v1beta1"
    @metadata = Psykube::Kubernetes::Shared::Metadata.new(name)
    @spec = Spec.new(name)
  end
end

require "./deployment/*"
