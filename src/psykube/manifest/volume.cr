require "yaml"
require "../kubernetes/deployment"

class Psykube::Manifest::Volume
  YAML.mapping({
    claim: Claim | Nil,
    spec:  Psykube::Kubernetes::Deployment::Spec::Template::Spec::Volume | Nil,
  })
end

require "./volume/*"
