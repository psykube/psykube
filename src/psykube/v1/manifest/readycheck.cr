class Psykube::V1::Manifest::Readycheck
  Macros.mapping({
    http:                  {type: Healthcheck::Http | String, nilable: true},
    tcp:                   {type: Healthcheck::Tcp | String | Int32, nilable: true},
    exec:                  {type: Healthcheck::Exec | String | Array(String), nilable: true},
    initial_delay_seconds: {type: Int32, nilable: true},
    timeout_seconds:       {type: Int32, nilable: true},
    period_seconds:        {type: Int32, nilable: true},
    success_threshold:     {type: Int32, nilable: true},
    failure_threshold:     {type: Int32, nilable: true},
  })
end

require "./healthcheck/*"
