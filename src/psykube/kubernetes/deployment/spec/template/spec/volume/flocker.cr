require "yaml"

class Psykube::Kubernetes::Deployment::Spec::Template::Spec::Volume::Flocker
  YAML.mapping({
    dataset_name: {type: String, key: "datasetName"},
  }, true)
end
