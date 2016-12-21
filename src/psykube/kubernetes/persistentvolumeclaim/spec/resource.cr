require "yaml"

class Psykube::Kubernetes::PersistentVolumeClaim::Spec::Resource
  YAML.mapping(
    limits: {type: Hash(String, String), nilable: true},
    requests: {type: Hash(String, String), nilable: true}
  )
end
