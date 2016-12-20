require "yaml"

class Psykube::Kubernetes::Deployment::Spec::Template::Spec::Volume::Nfs
  YAML.mapping({
    server:    {type: String},
    path:      {type: String, nilable: true},
    read_only: {type: Bool, nilable: true, key: "readOnly"},
  }, true)
end
