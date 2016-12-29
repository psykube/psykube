require "../../../../concerns/mapping"

class Psykube::Kubernetes::Pod::Spec::Container::Env::ValueFrom::FieldRef
  Kubernetes.mapping({
    api_version: String,
    field_path:  String,
  })
end
