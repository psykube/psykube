class Psykube::Manifest::Shared::InlineJob
  Macros.mapping({
    active_deadline: {type: Int32, optional: true},
    backoff_limit:   {type: Int32, optional: true},
    completions:     {type: Int32, optional: true},
    parallelism:     {type: Int32, optional: true},
    restart_policy:  {type: String, default: "OnFailure"},
    command:         {type: Array(String) | String, optional: true},
    args:            {type: Array(String) | String, optional: true},
  })
end
