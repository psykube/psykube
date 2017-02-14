require "../../concerns/mapping"

class Psykube::Kubernetes::LimitRange::Spec::Item
  Kubernetes.mapping({
    default:                 Hash(String, String)?,
    default_request:         Hash(String, String)?,
    max:                     Hash(String, String)?,
    max_limit_request_ratio: Hash(String, String)?,
    min:                     Hash(String, String)?,
    type:                    String?,
  })
end

require "./spec/*"
