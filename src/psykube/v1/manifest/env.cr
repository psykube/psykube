class Psykube::V1::Manifest::Env
  Macros.mapping({
    config_map:     {type: String | KeyRef, nilable: true},
    secret:         {type: String | KeyRef, nilable: true},
    field:          {type: FieldRef | String, nilable: true},
    resource_field: {type: ResourceFieldRef | String, nilable: true},
  })
end

require "./env/*"
