class Psykube::Manifest::Healthcheck::Tcp
  Manifest.mapping({
    port: {type: String | Int32, default: "default"},
  })
end
