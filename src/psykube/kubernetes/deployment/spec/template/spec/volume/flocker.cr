require "../../../../concerns/mapping"

class Psykube::Kubernetes::Deployment::Spec::Template::Spec::Volume::Flocker
  Kubernetes.mapping({
    dataset_name: String,
  })
end
