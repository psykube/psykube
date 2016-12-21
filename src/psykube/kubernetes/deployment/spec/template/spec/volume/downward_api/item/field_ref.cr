require "yaml"

class Psykube::Kubernetes::Deployment::Spec::Template::Spec::Volume::DownwardAPI::Item::FieldRef
  YAML.mapping({
    api_version: {type: String, key: "apiVersion"},
    field_path:  {type: String, key: "fieldPath"},
  }, true)
end
