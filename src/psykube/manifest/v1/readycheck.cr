class Psykube::Manifest::V1::Readycheck
  Manifest.mapping({
    http:                  {type: Healthcheck::Http | String, nilable: true},
    tcp:                   {type: Healthcheck::Tcp | String | Int32, nilable: true},
    exec:                  {type: Healthcheck::Exec | String | Array(String), nilable: true},
    initial_delay_seconds: Int32?,
    timeout_seconds:       Int32?,
    period_seconds:        Int32?,
    success_threshold:     Int32?,
    failure_threshold:     Int32?,
  })
end

require "./healthcheck/*"
