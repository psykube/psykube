require "../../../../concerns/mapping"

class Psykube::Kubernetes::Deployment::Spec::Template::Spec::Volume::AzureDisk
  Kubernetes.mapping({
    disk_name:    String,
    disk_uri:     {type: String, key: "diskURI"},
    caching_mode: String,
    fs_type:      String,
    read_only:    Bool | Nil,
  })
end
