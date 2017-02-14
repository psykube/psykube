require "../../concerns/mapping"
require "../../shared/selector"
require "../../pod_template/template"

class Psykube::Kubernetes::ReplicaSet::Spec
  Kubernetes.mapping({
    min_ready_seconds: Int32?,
    replicas:          Int32?,
    selector:          Shared::Selector?,
    template:          PodTemplate::Template?,
  })
end
