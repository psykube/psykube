require "../../../concerns/mapping"

class Psykube::Kubernetes::StatefulSet::Spec::UpdateStrategy::RollingUpdate
  Kubernetes.mapping({
    partition: Int32
  })
end
