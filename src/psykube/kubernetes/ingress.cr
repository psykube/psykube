require "./concerns/resource"
require "./shared/status"

class Psykube::Kubernetes::Ingress
  include Psykube::Kubernetes::Resource
  definition("extensions/v1beta1", "Ingress", {
    spec:   Psykube::Kubernetes::Ingress::Spec,
    status: {type: Shared::Status, nilable: true, setter: false, clean: true},
  })
end

require "./ingress/*"
