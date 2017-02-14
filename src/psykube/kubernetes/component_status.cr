require "./concerns/resource"

class Psykube::Kubernetes::ComponentStatus
  include Resource
  definition("v1", "ComponentStatus", {
    conditions: Array(Condition),
  })
end

require "./component_status/*"
