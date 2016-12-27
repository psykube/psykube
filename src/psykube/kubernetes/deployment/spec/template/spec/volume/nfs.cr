require "../../../../concerns/mapping"

class Psykube::Kubernetes::Deployment::Spec::Template::Spec::Volume::Nfs
  Kubernetes.mapping({
    server:    {type: String},
    path:      {type: String, nilable: true},
    read_only: {type: Bool, nilable: true, key: "readOnly"},
  })
end
