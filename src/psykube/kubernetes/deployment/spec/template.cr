require "yaml"
require "../../shared/metadata"

class Psykube::Kubernetes::Deployment::Spec::Template
  YAML.mapping(
    metadata: {type: Shared::Metadata},
    spec: {type: Spec}
  )

  def initialize(name : String)
    @metadata = Shared::Metadata.new
    @metadata.labels = {"app" => name}
    @spec = Spec.new
  end
end

require "./template/*"
