class Psykube::V2::Manifest::CronJob < ::Psykube::V2::Manifest
  declare("CronJob", {
    completions:                   {type: Int32, optional: true},
    parallelism:                   {type: Int32, optional: true},
    backoff_limit:                 {type: Int32, optional: true},
    active_deadline:               {type: Int32, optional: true},
    concurrency_policy:            {type: String, optional: true},
    failed_jobs_history_limit:     {type: Int32, optional: true},
    successful_jobs_history_limit: {type: Int32, optional: true},
    suspend:                       {type: Bool, optional: true},
    schedule:                      {type: String},
    starting_deadline:             {type: Int32, optional: true},
  }, service: false)

  @schedule = "0 0 5 31 2 ?" # A cron that will NEVER execute

  def jobs
    nil
  end

  def cron_jobs
    nil
  end
end
