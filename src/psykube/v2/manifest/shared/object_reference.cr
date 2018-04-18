class Psykube::V2::Manifest::Shared::ObjectReference
  Macros.mapping({
    api_version:      {type: String, optional: true},
    field_path:       {type: String, optional: true},
    kind:             {type: String, optional: true},
    name:             {type: String, optional: true},
    namespace:        {type: String, optional: true},
    resource_version: {type: String, optional: true},
    uid:              {type: String, optional: true},
  })
end
