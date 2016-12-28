require "yaml"
require "./shared/metadata"

class Psykube::Kubernetes::HorizontalPodAutoscaler
  YAML.mapping(
    kind: {type: String, default: "HorizontalPodAutoscaler"},
    api_version: {type: String, key: "apiVersion", default: "autoscaling/v1"},
    metadata: {type: Psykube::Kubernetes::Shared::Metadata},
    spec: {type: Spec},
    status: {type: Psykube::Kubernetes::HorizontalPodAutoscaler::Status, nilable: true}
  )

  def initialize(api_version : String, kind : String, name : String, min : UInt8, max : UInt8)
    @kind = "HorizontalPodAutoscaler"
    @api_version = "autoscaling/v1"
    @metadata = Psykube::Kubernetes::Shared::Metadata.new(name)
    @spec = Spec.new(api_version, kind, name, min, max)
  end
end

require "./horizontal_pod_autoscaler/*"
