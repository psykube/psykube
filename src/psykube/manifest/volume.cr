require "yaml"
require "../kubernetes/deployment"

class Psykube::Manifest::Volume
  YAML.mapping({
    claim: Claim | Nil,
    spec:  Spec | Nil,
  })

  def to_deployment_volume(name)
    spec = self.spec || Manifest::Volume::Spec.new(name, claim)
    spec.to_deployment_volume(name)
  end
end

require "./volume/*"
