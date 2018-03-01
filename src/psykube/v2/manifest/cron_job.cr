require "../../name_cleaner"

class Psykube::V2::Manifest::CronJob < ::Psykube::V2::Manifest
  declare("CronJob", {
    completions:                   {type: Int32, nilable: true},
    parallelism:                   {type: Int32, nilable: true},
    backoff_limit:                 {type: Int32, nilable: true},
    active_deadline:               {type: Int32, nilable: true},
    concurrency_policy:            {type: String, nilable: true},
    failed_jobs_history_limit:     {type: Int32, nilable: true},
    successful_jobs_history_limit: {type: Int32, nilable: true},
    suspend:                       {type: Bool, nilable: true},
    schedule:                      {type: String},
    starting_deadline:             {type: Int32, nilable: true},
  }, service: false)

  @schedule = "0 0 5 31 2 ?" # A cron that will NEVER execute
end
