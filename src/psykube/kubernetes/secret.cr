require "yaml"
require "./shared/metadata"

class Psykube::Kubernetes::Secret
  YAML.mapping(
    kind: {type: String, setter: false, default: "Secret"},
    apiVersion: {type: String, setter: false, default: "v1"},
    metadata: {type: Shared::Metadata, default: Shared::Metadata.new},
    data: {type: Hash(String, String), default: {} of String => String},
    stringData: {type: Hash(String, String), default: {} of String => String, nilable: true},
    type: {type: String, nilable: true}
  )

  def initialize
    @kind = "Secret"
    @apiVersion = "v1"
    @metadata = Shared::Metadata.new
    @data = {} of String => String
  end

  def initialize(name : String, data : Hash(String, String))
    initialize
    @metadata = Shared::Metadata.new(name)
    @data = data
  end
end
