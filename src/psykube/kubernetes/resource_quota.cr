require "./shared/metadata"
require "./concerns/resource"

class Psykube::Kubernetes::ResourceQuota
  Resource.definition("v1", "ResourceQuota", {
    spec:   Spec?,
    status: {type: Status, nilable: true, clean: true},
  })
end

require "./resource_quota/*"
