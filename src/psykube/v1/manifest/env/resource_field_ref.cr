class Psykube::V1::Manifest::Env::ResourceFieldRef
  Macros.mapping({
    resource:  {type: String},
    container: {type: String, optional: true},
    divisor:   {type: Int32, optional: true},
  })
end
