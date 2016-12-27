require "../../../../concerns/mapping"

class Psykube::Kubernetes::Deployment::Spec::Template::Spec::Volume::Flocker
  Kubernetes.mapping({
    dataset_name: {type: String, key: "datasetName"},
  })
end
