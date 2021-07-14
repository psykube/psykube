class Psykube::Manifest::Env
  Macros.mapping({
    config_map:     {type: String | KeyRef, optional: true},
    secret:         {type: String | KeyRef, optional: true},
    field:          {type: FieldRef | String, optional: true},
    resource_field: {type: ResourceFieldRef | String, optional: true},
  })
end

require "./env/*"
