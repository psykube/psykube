class Psykube::Manifest::Job < ::Psykube::Manifest
  declare("Job", {
    active_deadline: {type: Int32, optional: true},
    backoff_limit:   {type: Int32, optional: true},
    completions:     {type: Int32, optional: true},
    parallelism:     {type: Int32, optional: true},
  }, service: false)

  def jobs
    nil
  end

  def cron_jobs
    nil
  end
end
