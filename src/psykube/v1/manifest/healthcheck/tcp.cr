class Psykube::V1::Manifest::Healthcheck::Tcp
  Manifest.mapping({
    port: {type: String | Int32, default: "default"},
  })
end
