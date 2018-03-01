require "yaml"
require "../../name_cleaner"

class Psykube::V2::Manifest::CronJob < Manifest
  declare("CronJob", {
    concurrency_policy:            String?,
    failed_jobs_history_limit:     Int32?,
    successful_jobs_history_limit: Int32?,
    suspend:                       Bool?,
    schedule:                      String,
    starting_deadline:             Int32?,
  }, service: false)

  @schedule = "0 0 5 31 2 ?" # A cron that will NEVER execute
end
