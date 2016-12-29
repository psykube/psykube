require "../../concerns/mapping"

class Psykube::Kubernetes::HorizontalPodAutoscaler::Spec::ScaleTargetRef
  Kubernetes.mapping(
    kind: {type: String},
    name: {type: String},
    api_version: {type: String, key: "apiVersion"}
  )

  def initialize(@api_version : String, @kind : String, @name : String)
  end
end
