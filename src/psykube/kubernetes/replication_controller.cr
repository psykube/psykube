require "./shared/metadata"
require "./concerns/resource"

class Psykube::Kubernetes::ReplicationController
  include Resource
  definition("v1", "ReplicationController", {
    spec:   Spec?,
    status: {type: Status, nilable: true, clean: true},
  })

  def initialize(name : String)
    previous_def
    @spec = Spec.new(name)
  end
end

require "./replication_controller/*"
