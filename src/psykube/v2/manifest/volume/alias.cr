class Psykube::V2::Manifest::Volume::Alias
  Macros.mapping({
    secret:     {type: Array(String) | String, optional: true},
    config_map: {type: Array(String) | String, optional: true},
  })
end
