require "yaml"

class Psykube::Kubernetes::Deployment::Spec::Template::Spec::Volume
  class FlexVolume
    YAML.mapping({
      driver:     String,
      fs_type:    {type: String, key: "fsType"},
      secret_ref: {type: SecretRef, key: "secretRef"},
      read_only:  {type: Bool, nilable: true, key: "readOnly"},
      options:    Hash(String, String) | Nil,
    }, true)
  end
end

require "./shared/secret_ref"
