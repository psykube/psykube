require "yaml"
require "../../name_cleaner"

class Psykube::Manifest::V2::CronJob
  V2.declare_manifest("CronJob", {
    concurrency_policy:            String?,
    failed_jobs_history_limit:     Int32?,
    successful_jobs_history_limit: Int32?,
    suspend:                       Bool?,
    schedule:                      String,
    starting_deadline:             Int32?,
  }, service: false)

  @schedule = ""
end
