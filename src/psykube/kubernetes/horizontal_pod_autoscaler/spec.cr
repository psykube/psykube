require "../concerns/mapping"

class Psykube::Kubernetes::HorizontalPodAutoscaler::Spec
  Kubernetes.mapping(
    scale_target_ref: Psykube::Kubernetes::HorizontalPodAutoscaler::Spec::ScaleTargetRef,
    min_replicas: Int32?,
    max_replicas: Int32,
    target_cpu_utilization_percentage: {type: Int32, key: "targetCPUUtilizationPercentage", nilable: true}
  )

  def initialize(api_version : String, kind : String, name : String, min_replicas : Int32?, max_replicas : Int32)
    @min_replicas = min_replicas
    @max_replicas = max_replicas
    @scale_target_ref = Psykube::Kubernetes::HorizontalPodAutoscaler::Spec::ScaleTargetRef.new(api_version, kind, name)
  end
end

require "./spec/*"
