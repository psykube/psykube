require "../concerns/mapping"

class Psykube::Kubernetes::Deployment::Status
  Kubernetes.mapping({
    conditions:           {type: Array(Condition), setter: false, nilable: true},
    observed_generation:  {type: UInt32, setter: false, nilable: true},
    replicas:             {type: UInt32, setter: false, nilable: true},
    updated_replicas:     {type: UInt32, setter: false, nilable: true},
    available_replicas:   {type: UInt32, setter: false, nilable: true},
    unavailable_replicas: {type: UInt32, setter: false, nilable: true},
  })
end

require "./status/*"
