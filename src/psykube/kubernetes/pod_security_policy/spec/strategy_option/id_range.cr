require "../../../concerns/mapping"

class Psykube::Kubernetes::PodSecurityPolicy::Spec::StrategyOption::IDRange
  Kubernetes.mapping({
    min: Int64,
    max: Int64,
  })
end
