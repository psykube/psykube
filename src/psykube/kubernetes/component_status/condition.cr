require "../concerns/mapping"

class Psykube::Kubernetes::ComponentStatus::Condition
  Kubernetes.mapping({
    error:   String?,
    message: String?,
    status:  String?,
    type:    String?,
  })
end
