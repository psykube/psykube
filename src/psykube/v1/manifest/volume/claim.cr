class Psykube::V1::Manifest::Volume::Claim
  Manifest.mapping({
    annotations:   Hash(String, String)?,
    size:          String,
    storage_class: String?,
    access_modes:  {type: Array(String), default: ["ReadWriteOnce"]},
    read_only:     Bool?,
  })
end
