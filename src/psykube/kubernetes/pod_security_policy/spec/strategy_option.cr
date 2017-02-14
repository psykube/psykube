require "../../concerns/mapping"

class Psykube::Kubernetes::PodSecurityPolicy::Spec::StrategyOption
  Kubernetes.mapping({
    rule:   String,
    ranges: Array(IDRange)?,
  })
end

require "./strategy_option/*"
