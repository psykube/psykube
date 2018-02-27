class Psykube::Manifest::V1::Env::ResourceFieldRef
  Manifest.mapping({
    resource:  String,
    container: String?,
    divisor:   Int32?,
  })
end
