class Psykube::Manifest::Volume::Claim
  Macros.mapping({
    size:          {type: String},
    access_modes:  {type: Array(String), default: ["ReadWriteOnce"]},
    annotations:   {type: StringableMap, optional: true},
    storage_class: {type: String, optional: true},
    read_only:     {type: Bool, optional: true},
  })
end
