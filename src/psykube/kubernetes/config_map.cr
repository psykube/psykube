require "yaml"
require "./shared/metadata"

class Psykube::Kubernetes::ConfigMap
  YAML.mapping(
    kind: {type: String, setter: false, default: "ConfigMap"},
    api_version: { type: String, key: "apiVersion", default: "v1" },
    metadata: {type: Psykube::Kubernetes::Shared::Metadata, default: Psykube::Kubernetes::Shared::Metadata.new},
    data: {type: Hash(String, String), default: {} of String => String}
  )

  def initialize
    @kind = "ConfigMap"
    @api_version = "v1"
    @metadata = Psykube::Kubernetes::Shared::Metadata.new
    @data = {} of String => String
  end

  def initialize(name : String, data : Hash(String, String))
    initialize
    @metadata = Psykube::Kubernetes::Shared::Metadata.new(name)
    @data = data
  end
end
