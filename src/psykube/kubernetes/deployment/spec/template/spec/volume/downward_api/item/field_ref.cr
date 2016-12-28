require "../../../../../concerns/mapping"

class Psykube::Kubernetes::Deployment::Spec::Template::Spec::Volume::DownwardAPI::Item::FieldRef
  Kubernetes.mapping({
    api_version: String,
    field_path:  String,
  })
end
