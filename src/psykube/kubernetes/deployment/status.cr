require "../concerns/mapping"

class Psykube::Kubernetes::Deployment::Status
  Kubernetes.mapping({
    observed_generation:  {type: Int32, key: "observedGeneration", setter: false},
    replicas:             {type: Int32, setter: false},
    updated_replicas:     {type: Int32, key: "updatedReplicas", setter: false},
    available_replicas:   {type: Int32, key: "availableReplicas", setter: false},
    unavailable_replicas: {type: Int32, key: "unavailableReplicas", setter: false},
  })
end
