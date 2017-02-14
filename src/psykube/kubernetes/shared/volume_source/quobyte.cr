require "../../../concerns/mapping"

class Psykube::Kubernetes::Shared::VolumeSource::Quobyte
  Kubernetes.mapping({
    registry:  String,
    volume:    String,
    read_only: Bool?,
    user:      String,
    group:     String,
  })
end
