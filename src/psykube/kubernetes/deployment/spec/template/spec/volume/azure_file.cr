require "../../../../concerns/mapping"

class Psykube::Kubernetes::Deployment::Spec::Template::Spec::Volume::AzureFile
  Kubernetes.mapping({
    secret_name: {type: String, key: "secretName"},
    share_name:  {type: String, key: "shareName"},
    read_only:   {type: Bool, nilable: true, key: "readOnly"},
  })
end
