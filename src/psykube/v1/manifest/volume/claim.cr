class Psykube::V1::Manifest::Volume::Claim
  Macros.mapping({
    annotations:   {type: StringMap, optional: true},
    size:          {type: String},
    storage_class: {type: String, optional: true},
    access_modes:  {type: Array(String), default: ["ReadWriteOnce"]},
    read_only:     {type: Bool, optional: true},
  })
end
