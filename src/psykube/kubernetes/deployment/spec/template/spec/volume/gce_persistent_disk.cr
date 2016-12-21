require "yaml"

class Psykube::Kubernetes::Deployment::Spec::Template::Spec::Volume::GcePersistentDisk
  YAML.mapping({
    pd_name:   {type: String, key: "pdName"},
    fs_type:   {type: String, key: "fsType"},
    partition: {type: UInt16, nilable: true},
    read_only: {type: Bool, nilable: true, key: "readOnly"},
  }, true)
end
