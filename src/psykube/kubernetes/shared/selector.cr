require "../concerns/mapping"

class Psykube::Kubernetes::Shared::Selector
  alias MatchLabels = Hash(String, String)

  Kubernetes.mapping({
    match_labels:      MatchLabels?,
    match_expressions: Array(MatchExpression)?,
  })

  def initialize(app_label : String)
    initialize({"app" => app_label})
  end

  def initialize(@match_labels : MatchLabels)
  end
end

require "./selector/*"
