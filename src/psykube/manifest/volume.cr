require "../kubernetes/deployment"

class Psykube::Manifest::Volume
  Manifest.mapping({
    claim:      Claim?,
    spec:       Spec?,
    secret:     Array(String) | String | Spec::KubeVolume::Source::Secret::KeyToPath | Spec::KubeVolume::Source::Secret | Nil,
    config_map: Array(String) | String | Spec::KubeVolume::Source::ConfigMap::KeyToPath | Spec::KubeVolume::Source::ConfigMap | Nil,
  })

  def to_deployment_volume(name : String, volume_name : String)
    spec = self.spec || Manifest::Volume::Spec.new
    spec.set_persistent_volume_claim claim, volume_name: volume_name
    spec.set_secret secret, name: name if secret
    spec.set_config_map config_map, name: name if config_map
    spec.to_deployment_volume(volume_name)
  end
end

require "./volume/*"
