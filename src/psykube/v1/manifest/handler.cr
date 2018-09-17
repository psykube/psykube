class Psykube::V1::Manifest::Handler
  Macros.mapping({
    http:                  {type: Handler::Http | String, optional: true},
    tcp:                   {type: Handler::Tcp | String | Int32, optional: true},
    exec:                  {type: Handler::Exec | String | Array(String), optional: true},
  })
end

require "./handler/*"
