class Psykube::V2::Manifest::Shared::Role
  Macros.mapping({
    name:  {type: String},
    rules: {type: Array(Rule)},
  })
end

require "./role/*"
