require "../../../concerns/mapping"

class Psykube::Kubernetes::Pod::Spec::Volume::Flocker
  Kubernetes.mapping({
    dataset_name: String,
  })
end
