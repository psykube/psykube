class Psykube::V2::Manifest::Shared::Role::Rule
  Macros.mapping({
    api_groups:        {type: Array(String), default: [""]},
    non_resource_urls: {type: Array(String), optional: true},
    resource_names:    {type: Array(String), optional: true},
    resources:         {type: Array(String), optional: true},
    verbs:             {type: Array(String)},
  })
end
