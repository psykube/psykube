require "./shared/local_object_reference"
require "./shared/object_reference"
require "./concerns/resource"

class Psykube::Kubernetes::ServiceAccount
  include Resource
  definition("v1", "ServiceAccount", {
    image_pull_secrets: Array(Shared::LocalObjectReference)?,
    secrets:            Array(Shared::ObjectReference)?,
  })
end

require "./resource_quota/*"
