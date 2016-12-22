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

  def initialize(name : String, size : String)
    @kind = "PersistentVolumeClaim"
    @api_version = "v1"
    @metadata = Psykube::Kubernetes::Shared::Metadata.new(name)
    @spec = Psykube::Kubernetes::PersistentVolumeClaim::Spec.new(size)
  end

  def initialize(name : String, size : String, access_modes : Array(String))
    @kind = "PersistentVolumeClaim"
    @api_version = "v1"
    @metadata = Psykube::Kubernetes::Shared::Metadata.new(name)
    @spec = Psykube::Kubernetes::PersistentVolumeClaim::Spec.new(size, access_modes)
  end
end

require "./persistent_volume_claim/*"
