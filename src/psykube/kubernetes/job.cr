require "./concerns/resource"

class Psykube::Kubernetes::Job
  include Resource
  definition("batch/v1", "Job", {
    spec:   Spec?,
    status: {type: Status, nilable: true, clean: true},
  })
end

require "./job/*"
