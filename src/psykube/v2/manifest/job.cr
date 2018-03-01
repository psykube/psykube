require "yaml"
require "../../name_cleaner"

class Psykube::V2::Manifest::Job < Manifest
  declare("Job", {
    active_deadline: Int32?,
    backoff_limit:   Int32?,
    completions:     Int32?,
    parallelism:     Int32?,
  }, service: false)
end
