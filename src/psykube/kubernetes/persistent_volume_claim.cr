require "yaml"
require "./shared/metadata"

class Psykube::Kubernetes::PersistentVolumeClaim
  YAML.mapping(
    kind: {type: String, setter: false, default: "ConfigMap"},
    api_version: {type: String, key: "apiVersion", default: "v1"},
    metadata: {type: Psykube::Kubernetes::Shared::Metadata, default: Psykube::Kubernetes::Shared::Metadata.new},
    spec: {type: Psykube::Kubernetes::PersistentVolumeClaim::Spec},
    status: {type: Psykube::Kubernetes::PersistentVolumeClaim::Status, nilable: true}
  )

  def initialize
    @kind = "PersistentVolumeClaim"
    @api_version = "v1"
    @metadata = Psykube::Kubernetes::Shared::Metadata.new
    @spec = Psykube::Kubernetes::PersistentVolumeClaim::Spec.new
  end
end

require "./persistentvolumeclaim/*"
