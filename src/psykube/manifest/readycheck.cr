class Psykube::Manifest::Readycheck
  Manifest.mapping({
    http: {type: Healthcheck::Http, nilable: true},
    tcp:  {type: Healthcheck::Tcp, nilable: true},
    exec: {type: Healthcheck::Exec, nilable: true},
  })
end

require "./healthcheck/*"
