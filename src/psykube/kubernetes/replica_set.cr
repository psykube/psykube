require "./shared/metadata"
require "./concerns/resource"

class Psykube::Kubernetes::ReplicaSet
  Resource.definition("extensions/v1beta1", "ReplicaSet", {
    spec:   Spec?,
    status: {type: Status, nilable: true, clean: true},
  })

  def initialize(name : String)
    previous_def
    @spec = Spec.new(name)
  end
end

require "./replica_set/*"
