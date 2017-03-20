class Psykube::Manifest::Resources
  Manifest.mapping({
    limits:   Requirement?,
    requests: Requirement?,
  })
end

require "./resources/*"
