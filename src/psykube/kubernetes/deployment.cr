require "yaml"
require "./shared/metadata"
require "./concerns/resource"

class Psykube::Kubernetes::Deployment
  Resource.definition("extensions/v1beta1", "Deployment", {
    spec:   {type: Spec, default: Spec.new("")},
    status: {type: Status, nilable: true, setter: false},
  })

  def initialize(name : String)
    initialize
    @metadata = Shared::Metadata.new(name)
    @spec = Spec.new(name)
  end
end

require "./deployment/*"
