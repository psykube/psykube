require "../../concerns/mapping"

class Psykube::Kubernetes::ResourceQuota::Status
  Kubernetes.mapping({
    hard: Hash(String, String)?,
    used: Hash(String, String)?,
  })
end
