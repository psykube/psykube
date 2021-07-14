class Psykube::Manifest::Env::KeyRef
  Macros.mapping({
    name:     {type: String},
    key:      {type: String},
    optional: {type: Bool, default: false},
  })
end
