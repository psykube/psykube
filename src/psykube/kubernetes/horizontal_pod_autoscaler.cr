require "./shared/metadata"
require "./concerns/resource"

class Psykube::Kubernetes::HorizontalPodAutoscaler
  include Psykube::Kubernetes::Resource
  definition("autoscaling/v1", "HorizontalPodAutoscaler", {
    spec:   {type: Spec, nilable: true},
    status: {type: Status, nilable: true, clean: true, setter: false},
  })

  def initialize(api_version : String, kind : String, name : String, min : UInt8, max : UInt8)
    initialize(name)
    @spec = Spec.new(api_version, kind, name, min, max)
  end
end

require "./horizontal_pod_autoscaler/*"
