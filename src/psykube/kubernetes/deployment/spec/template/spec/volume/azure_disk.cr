require "../../../../concerns/mapping"

class Psykube::Kubernetes::Deployment::Spec::Template::Spec::Volume::AzureDisk
  Kubernetes.mapping({
    disk_name:    {type: String, key: "diskName"},
    disk_uri:     {type: String, key: "diskURI"},
    caching_mode: {type: String, key: "cachingMode"},
    fs_type:      {type: String, key: "fsType"},
    read_only:    {type: Bool, nilable: true, key: "readOnly"},
  })
end
