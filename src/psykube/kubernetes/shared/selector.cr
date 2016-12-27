require "../concerns/mapping"

class Psykube::Kubernetes::Shared::Selector
  alias MatchLabels = Hash(String, String)

  Kubernetes.mapping({
    match_labels:      {type: MatchLabels, nilable: true},
    match_expressions: {type: Array(MatchExpression), nilable: true},
  })

  def initialize(app_label : String)
    initialize({"app" => app_label})
  end

  def initialize(@match_labels : MatchLabels)
  end
end

require "./selector/*"
