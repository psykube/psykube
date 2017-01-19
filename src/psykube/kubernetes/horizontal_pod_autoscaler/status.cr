require "../concerns/mapping"

class Psykube::Kubernetes::HorizontalPodAutoscaler::Status
  Kubernetes.mapping(
    observed_generation: {type: UInt8, key: "observedGeneration", nilable: true},
    last_scale_time: {type: String, key: "lastScaleTime"},
    current_replicas: {type: UInt8, key: "currentReplicas"},
    desired_replicas: {type: UInt8, key: "desiredReplicas"},
    current_cpu_utilization_percentage: {type: UInt8, key: "currentCPUUTilizationPercentage"}
  )
end
