require "yaml"

class Psykube::Kubernetes::Shared::Selector::MatchExpression
  YAML.mapping({
    key:      String,
    operator: String,
    values:   Array(String),
  }, true)

  def initialize(key : String, operator : String, value : String)
    initialize(key, operator, [value])
  end

  def initialize(@key : String, @operator : String, @values : Array(String))
  end
end
