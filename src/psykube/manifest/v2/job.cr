require "yaml"
require "../../name_cleaner"

class Psykube::Manifest::V2::Job
  V2.declare_manifest("Job", {
    active_deadline: Int32?,
    backoff_limit:   Int32?,
    completions:     Int32?,
    parallelism:     Int32?,
  }, service: false)
end
