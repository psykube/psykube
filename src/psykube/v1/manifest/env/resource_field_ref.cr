class Psykube::V1::Manifest::Env::ResourceFieldRef
  Macros.mapping({
    resource:  {type: String},
    container: {type: String, nilable: true},
    divisor:   {type: Int32, nilable: true},
  })
end
