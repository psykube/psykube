class Psykube::Manifest::Volume::Claim
  Manifest.mapping({
    size:          String,
    storage_class: String?,
    access_modes:  {type: Array(String), default: ["ReadWriteOnce"]},
    read_only:     Bool?,
  })
end
