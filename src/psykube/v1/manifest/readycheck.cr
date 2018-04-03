class Psykube::V1::Manifest::Readycheck
  Macros.mapping({
    http:                  {type: Healthcheck::Http | String, optional: true},
    tcp:                   {type: Healthcheck::Tcp | String | Int32, optional: true},
    exec:                  {type: Healthcheck::Exec | String | Array(String), optional: true},
    initial_delay_seconds: {type: Int32, optional: true},
    timeout_seconds:       {type: Int32, optional: true},
    period_seconds:        {type: Int32, optional: true},
    success_threshold:     {type: Int32, optional: true},
    failure_threshold:     {type: Int32, optional: true},
  })
end

require "./healthcheck/*"
