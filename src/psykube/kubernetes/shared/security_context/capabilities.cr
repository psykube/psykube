require "yaml"

class Psykube::Kubernetes::Shared::SecurityContext::Capabilities
  YAML.mapping({
    add:    Array(Hash(String, String)) | Nil,
    remove: Array(Hash(String, String)) | Nil,
  }, true)
end
