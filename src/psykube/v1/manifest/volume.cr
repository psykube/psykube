class Psykube::V1::Manifest::Volume
  Macros.mapping({
    claim:      {type: Claim, nilable: true},
    spec:       {type: Spec, nilable: true},
    secret:     {type: Array(String) | String | Array(Pyrite::Api::Core::V1::KeyToPath) | Pyrite::Api::Core::V1::SecretVolumeSource, nilable: true},
    config_map: {type: Array(String) | String | Array(Pyrite::Api::Core::V1::KeyToPath) | Pyrite::Api::Core::V1::ConfigMapVolumeSource, nilable: true},
  })

  def to_deployment_volume(name : String, volume_name : String)
    spec = self.spec || Manifest::Volume::Spec.new
    spec.set_persistent_volume_claim claim, name: volume_name
    spec.set_secret secret, name: name if secret
    spec.set_config_map config_map, name: name if config_map
    spec.to_deployment_volume(volume_name)
  end
end

require "./volume/*"
