require "yaml"

class Psykube::Kubernetes::PersistentVolumeClaim::Spec::Selector::MatchExpression
  YAML.mapping(
    key: {type: String},          # nilable?
    operator: {type: String},     # nilable?
    values: {type: Array(String)} # nilable?
  )
end
