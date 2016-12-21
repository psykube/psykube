require "yaml"

class Psykube::Kubernetes::Deployment::Spec::Template::Spec::Container::Env::ValueFrom::FieldRef
  YAML.mapping({
    api_version: {type: String, key: "apiVersion"},
    field_path:  {type: String, key: "fieldPath"},
  }, true)
end
