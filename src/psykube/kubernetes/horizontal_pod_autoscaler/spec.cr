require "yaml"

class Psykube::Kubernetes::HorizontalPodAutoscaler::Spec
  YAML.mapping(
    scale_target_ref: {type: Psykube::Kubernetes::HorizontalPodAutoscaler::Spec::ScaleTargetRef, key: "scaleTargetRef"},
    min_replicas: {type: UInt8, key: "minReplicas"},
    max_replicas: {type: UInt8, key: "maxReplicas"},
    target_cpu_utilization_percentage: {type: UInt8, key: "targetCPUUtilizationPercentage", default: 0}
  )

  def initialize(api_version : String, kind : String, name : String, min_replicas : UInt8, max_replicas : UInt8)
    @min_replicas = min_replicas
    @max_replicas = max_replicas
    @scale_target_ref = Psykube::Kubernetes::HorizontalPodAutoscaler::Spec::ScaleTargetRef.new(api_version, kind, name)
    @target_cpu_utilization_percentage = 0.to_u8
  end
end

require "./spec/*"
