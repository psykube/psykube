require "../../concerns/mapping"
require "../../shared/metadata"

class Psykube::Kubernetes::Deployment::Spec::Template
  Kubernetes.mapping(
    metadata: Shared::Metadata,
    spec: Spec
  )

  def initialize(name : String)
    @metadata = Shared::Metadata.new
    @metadata.labels = {"app" => name}
    @spec = Spec.new
  end
end

require "./template/*"
