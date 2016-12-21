require "yaml"

class Psykube::Kubernetes::Deployment::Spec::Template::Spec::Volume::Iscsi
  YAML.mapping({
    target_portal:   {type: String, key: "targetPortal"},
    iqn:             {type: String},
    lun:             {type: UInt16},
    iscsi_interface: {type: String, key: "iscsiInterface"},
    fs_type:         {type: String, key: "fsType"},
    read_only:       {type: Bool, nilable: true, key: "readOnly"},
  }, true)
end
