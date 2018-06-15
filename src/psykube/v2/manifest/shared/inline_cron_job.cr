class Psykube::V2::Manifest::Shared::InlineCronJob
  Macros.mapping({
    completions:                   {type: Int32, optional: true},
    parallelism:                   {type: Int32, optional: true},
    backoff_limit:                 {type: Int32, optional: true},
    active_deadline:               {type: Int32, optional: true},
    concurrency_policy:            {type: String, optional: true},
    failed_jobs_history_limit:     {type: Int32, optional: true},
    successful_jobs_history_limit: {type: Int32, optional: true},
    suspend:                       {type: Bool, optional: true},
    starting_deadline:             {type: Int32, optional: true},
    schedule:                      {type: String},
    command:                       {type: Array(String) | String},
  })
end
