class Psykube::V1::Manifest::Volume::Claim
  Macros.mapping({
    annotations:   {type: StringMap, nilable: true},
    size:          {type: String},
    storage_class: {type: String, nilable: true},
    access_modes:  {type: Array(String), default: ["ReadWriteOnce"]},
    read_only:     {type: Bool, nilable: true},
  })
end
