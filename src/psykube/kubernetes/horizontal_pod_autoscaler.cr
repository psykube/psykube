require "yaml"
require "./shared/metadata"

class Psykube::Kubernetes::HorizontalPodAutoscaler
  YAML.mapping(
    kind: {type: String, default: "HorizontalPodAutoscaler"},
    api_version: {type: String, key: "apiVersion", default: "autoscaling/v1"},
    metadata: {type: Psykube::Kubernetes::Shared::Metadata},
    spec: {type: Psykube::Kubernetes::HorizontalPodAutoscaler::Spec},
    status: {type: Psykube::Kubernetes::HorizontalPodAutoscaler::Status}
  )

  def initialize
    @kind = "HorizontalPodAutoscaler"
    @api_version = "autoscaling/v1"
    @metadata = Psykube::Kubernetes::Shared::Metadata.new(name)
    @spec = Psykube::Kubernetes::HorizontalPodAutoscaler::Spec.new(0, 1, name) # ?????
    @status = Psykube::Kubernetes::HorizontalPodAutoscaler::Status.new         # ????
  end
end

require "./horizontal_pod_autoscaler/*"
