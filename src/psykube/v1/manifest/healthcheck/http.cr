class Psykube::V1::Manifest::Healthcheck::Http
  Macros.mapping({
    path:    {type: String, default: "/"},
    port:    {type: String | Int32, default: "default"},
    host:    {type: String, nilable: true},
    scheme:  {type: String, nilable: true},
    headers: {type: StringMap, nilable: true},
  })
end
