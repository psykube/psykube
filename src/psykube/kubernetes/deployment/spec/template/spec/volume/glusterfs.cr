require "yaml"

class Psykube::Kubernetes::Deployment::Spec::Template::Spec::Volume::Glusterfs
  YAML.mapping({
    endpoints: String,
    path:      String | Nil,
    read_only: {type: Bool, nilable: true, key: "readOnly"},
  }, true)
end
