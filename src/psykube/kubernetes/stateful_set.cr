require "./shared/local_object_reference"
require "./shared/object_reference"
require "./concerns/resource"

class Psykube::Kubernetes::StatefulSet
  Resource.definition("apps/v1beta1", "StatefulSet", {
    spec:   Spec?,
    status: {type: Status, nilable: true, clean: true},
  })

  def initialize(name : String, service_name : String)
    initialize(name)
    @spec = Spec.new(name, service_name)
  end
end

require "./stateful_set/*"
