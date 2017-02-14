require "../../concerns/mapping"

class Psykube::Kubernetes::Job::Status
  Kubernetes.mapping({
    active:          Int32?,
    completion_time: Time?,
    conditions:      Array(Condition)?,
    failed:          Int32?,
    start_time:      Time?,
    succeeded:       Int32?,
  })
end

require "./status/*"
