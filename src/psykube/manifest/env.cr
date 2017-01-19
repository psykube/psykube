class Psykube::Manifest::Env
  Manifest.mapping({
    config_map:     String | KeyRef | Nil,
    secret:         String | KeyRef | Nil,
    field:          FieldRef | String | Nil,
    resource_field: ResourceFieldRef | String | Nil,
  })
end

require "./env/*"
