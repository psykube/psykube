class Psykube::V1::Manifest::Handler::Http
  Macros.mapping({
    path:    {type: String, default: "/"},
    port:    {type: String | Int32, default: "default"},
    host:    {type: String, optional: true},
    scheme:  {type: String, optional: true},
    headers: {type: StringMap, optional: true},
  })
end
