require "../../concerns/mapping"

class Psykube::Kubernetes::Shared::Selector::MatchExpression
  Kubernetes.mapping({
    key:      String,
    operator: String,
    values:   Array(String),
  })

  def initialize(key : String, operator : String, value : String)
    initialize(key, operator, [value])
  end

  def initialize(@key : String, @operator : String, @values : Array(String))
  end
end
