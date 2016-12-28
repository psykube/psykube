require "../../../../concerns/mapping"

class Psykube::Kubernetes::Deployment::Spec::Template::Spec::Volume::AzureFile
  Kubernetes.mapping({
    secret_name: String,
    share_name:  String,
    read_only:   Bool | Nil,
  })
end
