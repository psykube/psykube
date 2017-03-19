require "./shared/metadata"
require "./concerns/resource"

class Psykube::Kubernetes::HorizontalPodAutoscaler
  include Resource
  definition("autoscaling/v1", "HorizontalPodAutoscaler", {
    spec:   Spec?,
    status: {type: Status, nilable: true, clean: true},
  })

  def initialize(api_version : String, kind : String, name : String, min : Int32?, max : Int32)
    initialize(name)
    @spec = Spec.new(api_version, kind, name, min, max)
  end
end

require "./horizontal_pod_autoscaler/*"
