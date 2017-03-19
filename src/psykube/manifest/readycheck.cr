class Psykube::Manifest::Readycheck
  Manifest.mapping({
    http:                  {type: Healthcheck::Http | String, nilable: true},
    tcp:                   {type: Healthcheck::Tcp | String | UInt16, nilable: true},
    exec:                  {type: Healthcheck::Exec | String | Array(String), nilable: true},
    initial_delay_seconds: UInt32?,
    timeout_seconds:       UInt32?,
    period_seconds:        UInt32?,
    success_threshold:     UInt32?,
    failure_threshold:     UInt32?,
  })
end

require "./healthcheck/*"
