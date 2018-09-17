class Psykube::V1::Manifest::Healthcheck
  Macros.mapping({
    readiness:             {type: Bool, default: true},
    http:                  {type: Handler::Http | String, optional: true},
    tcp:                   {type: Handler::Tcp | String | Int32, optional: true},
    exec:                  {type: Handler::Exec | String | Array(String), optional: true},
    initial_delay_seconds: {type: Int32, optional: true},
    timeout_seconds:       {type: Int32, optional: true},
    period_seconds:        {type: Int32, optional: true},
    success_threshold:     {type: Int32, optional: true},
    failure_threshold:     {type: Int32, optional: true},
  })
end

require "./handler/*"
