require "yaml"

class Psykube::Kubernetes::Namespace::Spec
  YAML.mapping(
    finalizers: Array(String)
  )
end
