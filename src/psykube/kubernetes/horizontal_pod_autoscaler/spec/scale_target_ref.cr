require "yaml"

class Psykube::Kubernetes::HorizontalPodAutoscaler::Spec::ScaleTargetRef
  YAML.mapping(
    kind: {type: String},
    name: {type: String},
    api_version: {type: String, key: "apiVersion"}
  )

  def initialize(name : String)
    @name = name
    @kind = "HorizontalPodAutoscaler"
    @api_version = "autoscaling/v1"
  end
end
