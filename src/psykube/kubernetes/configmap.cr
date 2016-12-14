require "yaml"
require "./shared/metadata"

class Psykube::Kuberenetes::ConfigMap

  YAML.mapping(
    kind: String,
    apiVersion: String,
    metadata: { type: Psykube::Kubernetes::Shared::Metadata },
    data: { type: Hash(String, String), default: {} of String => String }
  )

end
