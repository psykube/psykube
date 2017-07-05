require "./shared/metadata"
require "./concerns/resource"

class Psykube::Kubernetes::DaemonSet
  Resource.definition("extensions/v1beta1", "DaemonSet", {
    spec:   Spec?,
    status: {type: Status, nilable: true, clean: true},
  })

  def initialize(name : String)
    initialize
    @metadata = Shared::Metadata.new(name)
    @spec = Spec.new(name)
  end
end

require "./daemon_set/*"
