require "../kubernetes/horizontal_pod_autoscaler"

class Psykube::Generator
  module HorizontalPodAutoscaler
    @horizontal_pod_autoscaler : Psykube::Kubernetes::HorizontalPodAutoscaler
    getter horizontal_pod_autoscaler
  end
end
