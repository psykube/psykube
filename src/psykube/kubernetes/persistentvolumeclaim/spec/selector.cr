require "yaml"

class Psykube::Kubernetes::PersistentVolumeClaim::Spec::Selector
  YAML.mapping(
    match_labels: {type: Hash(String, String), key: "matchLabels", nilable: true},
    match_expressions: {type: Array(MatchExpression), key: "matchExpressions", nilable: true},
  )
end

require "./selector/*"
