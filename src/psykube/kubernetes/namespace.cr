require "yaml"

class Psykube::Kubernetes::Namespace
  YAML.mapping(
    apiVersion: String,
    kind: String,
    spec: Spec
  )

  class Spec
    YAML.mapping(
      finalizers: Array(String)
    )
  end
end
