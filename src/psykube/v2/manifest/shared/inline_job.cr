class Psykube::V2::Manifest::Shared::InlineJob
  Macros.mapping({
    active_deadline: {type: Int32, optional: true},
    backoff_limit:   {type: Int32, optional: true},
    completions:     {type: Int32, optional: true},
    parallelism:     {type: Int32, optional: true},
    command:         {type: Array(String) | String},
  })
end
