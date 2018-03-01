require "../../name_cleaner"

class Psykube::V2::Manifest::Job < ::Psykube::V2::Manifest
  declare("Job", {
    active_deadline: {type: Int32, nilable: true},
    backoff_limit:   {type: Int32, nilable: true},
    completions:     {type: Int32, nilable: true},
    parallelism:     {type: Int32, nilable: true},
  }, service: false)
end
