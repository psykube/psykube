require "yaml"
require "./shared/metadata"
require "./concerns/resource"

class Psykube::Kubernetes::Pod
  Resource.definition("extensions/v1beta1", "Pod", {
    spec:   {type: Spec},
    status: {type: Status, nilable: true, setter: false},
  })
end

require "./pod/*"
