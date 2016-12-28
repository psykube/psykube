require "../concerns/mapping"

class Psykube::Kubernetes::Deployment::Status
  Kubernetes.mapping({
    observed_generation:  {type: Int32, setter: false},
    replicas:             {type: Int32, setter: false},
    updated_replicas:     {type: Int32, setter: false},
    available_replicas:   {type: Int32, setter: false},
    unavailable_replicas: {type: Int32, setter: false},
  })
end
