class Psykube::Manifest::Handler::Http
  Macros.mapping({
    path:    {type: String, default: "/"},
    port:    {type: String | Int32, optional: true},
    host:    {type: String, optional: true},
    scheme:  {type: String, optional: true},
    headers: {type: StringableMap, optional: true},
  })
end
