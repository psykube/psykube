require "../concerns/mapping"

class Psykube::Kubernetes::DaemonSet::Status
  Kubernetes.mapping({
    current_number_scheduled: Int32,
    desired_number_scheduled: Int32,
    number_mischeduled:       Int32,
    number_ready:             Int32,
  })
end
