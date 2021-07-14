class Psykube::Manifest::Shared::Role
  Macros.mapping({
    name:  {type: String},
    rules: {type: Array(Rule)},
  })
end

require "./role/*"
