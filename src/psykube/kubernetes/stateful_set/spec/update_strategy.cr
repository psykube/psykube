require "../../concerns/mapping"

class Psykube::Kubernetes::StatefulSet::Spec::UpdateStrategy
  Kubernetes.mapping({
    type: String?,
    rolling_update: RollingUpdate?
  })
end

require "./update_strategy/*"
