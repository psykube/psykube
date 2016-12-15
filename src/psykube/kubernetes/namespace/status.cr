require "yaml"

class Psykube::Kubernetes::Namespace::Status
  YAML.mapping(
    phase: String
  )
end
