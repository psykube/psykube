class Psykube::Manifest::V1::Healthcheck
  Manifest.mapping({
    readiness:             {type: Bool, default: true},
    http:                  {type: Http | String, nilable: true},
    tcp:                   {type: Tcp | String | Int32, nilable: true},
    exec:                  {type: Exec | String | Array(String), nilable: true},
    initial_delay_seconds: Int32?,
    timeout_seconds:       Int32?,
    period_seconds:        Int32?,
    success_threshold:     Int32?,
    failure_threshold:     Int32?,
  })
end

require "./healthcheck/*"
