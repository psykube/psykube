class Psykube::Manifest::Healthcheck::Tcp
  Manifest.mapping({
    port: {type: String | UInt16, default: "default"},
  })
end
