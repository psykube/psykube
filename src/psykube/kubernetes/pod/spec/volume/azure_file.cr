require "../../../concerns/mapping"

class Psykube::Kubernetes::Pod::Spec::Volume::AzureFile
  Kubernetes.mapping({
    secret_name: String,
    share_name:  String,
    read_only:   Bool?,
  })
end
