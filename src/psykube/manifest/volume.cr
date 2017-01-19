require "../kubernetes/deployment"

class Psykube::Manifest::Volume
  Manifest.mapping({
    claim: Claim?,
    spec:  Spec?,
  })

  def to_deployment_volume(name)
    spec = self.spec || Manifest::Volume::Spec.new(name, claim)
    spec.to_deployment_volume(name)
  end
end

require "./volume/*"
