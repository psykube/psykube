class Psykube::Manifest::V1::Healthcheck::Tcp
  Manifest.mapping({
    port: {type: String | Int32, default: "default"},
  })
end
