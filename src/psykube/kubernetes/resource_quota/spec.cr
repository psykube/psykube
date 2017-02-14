require "../../concerns/mapping"

class Psykube::Kubernetes::ResourceQuota::Spec
  Kubernetes.mapping({
    hard:   Hash(String, String)?,
    scopes: Array(String)?,
  })
end
