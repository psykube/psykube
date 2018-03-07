class Psykube::V2::Manifest::Shared::InlineCronJob
  delegate env, volumes, to: container

  Macros.mapping({
    schedule:                      {type: String},
    container:                     {type: Shared::Container},
    completions:                   {type: Int32, optional: true},
    restart_policy:                {type: String, optional: true},
    parallelism:                   {type: Int32, optional: true},
    backoff_limit:                 {type: Int32, optional: true},
    active_deadline:               {type: Int32, optional: true},
    concurrency_policy:            {type: String, optional: true},
    failed_jobs_history_limit:     {type: Int32, optional: true},
    successful_jobs_history_limit: {type: Int32, optional: true},
    suspend:                       {type: Bool, optional: true},
    starting_deadline:             {type: Int32, optional: true},
  })

  @schedule = "0 0 5 31 2 ?" # A cron that will NEVER execute

  def init_containers
    ContainerMap.new
  end
end
