require "yaml"
require "./shared/metadata"

class Psykube::Kubernetes::Namespace
  YAML.mapping(
    api_version: {type: String, key: "apiVersion", default: "v1"},
    kind: {type: String, key: "apiVersion", default: "Namespace"},
    spec: {type: Spec, nilable: true},
    status: {type: Status, nilable: true},
    metadata: {type: Kubernetes::Shared::Metadata}
  )

  def initialize(name : String)
    @api_version = "v1"
    @kind = "Namespace"
    @metadata = Kubernetes::Shared::Metadata.new
  end
end

require "./namespace/*"
