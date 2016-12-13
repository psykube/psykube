require "yaml"

class Psykube::Kuberenetes::Namespace

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
