require "../../../../../concerns/mapping"

class Psykube::Kubernetes::Deployment::Spec::Template::Spec::Container::Env::ValueFrom::FieldRef
  Kubernetes.mapping({
    api_version: {type: String, key: "apiVersion"},
    field_path:  {type: String, key: "fieldPath"},
  })
end
