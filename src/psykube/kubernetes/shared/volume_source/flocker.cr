require "../../../concerns/mapping"

class Psykube::Kubernetes::Shared::VolumeSource::Flocker
  Kubernetes.mapping({
    dataset_name: String,
  })
end
