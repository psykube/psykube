require "./concerns/resource"

class Psykube::Kubernetes::NetworkPolicy
  include Resource
  definition("extensions/v1beta1", "NetworkPolicy", {
    spec: Spec?,
  })
end

require "./network_policy/*"
