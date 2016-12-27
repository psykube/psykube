require "../../../../../concerns/mapping"

class Psykube::Kubernetes::Deployment::Spec::Template::Spec::Volume::DownwardAPI::Item::FieldRef
  Kubernetes.mapping({
    api_version: {type: String, key: "apiVersion"},
    field_path:  {type: String, key: "fieldPath"},
  })
end
