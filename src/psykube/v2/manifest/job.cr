class Psykube::V2::Manifest::Job < ::Psykube::V2::Manifest
  declare("Job", {
    active_deadline: {type: Int32, optional: true},
    backoff_limit:   {type: Int32, optional: true},
    completions:     {type: Int32, optional: true},
    parallelism:     {type: Int32, optional: true},
  }, service: false, jobs: false)
end
