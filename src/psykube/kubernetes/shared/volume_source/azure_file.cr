require "../../../concerns/mapping"

class Psykube::Kubernetes::Shared::VolumeSource::AzureFile
  Kubernetes.mapping({
    secret_name: String,
    share_name:  String,
    read_only:   Bool?,
  })
end
