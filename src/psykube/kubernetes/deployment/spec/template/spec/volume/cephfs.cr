require "yaml"

class Psykube::Kubernetes::Deployment::Spec::Template::Spec::Volume
  class Cephfs
    YAML.mapping({
      monitors:    {type: Array(String)},
      path:        String,
      user:        String,
      keyring:     String,
      secret_file: {type: String, key: "secretFile"},
      secret_ref:  {type: SecretRef, key: "secretRef"},
      read_only:   {type: Bool, nilable: true, key: "readOnly"},
    }, true)
  end
end

require "./shared/secret_ref"
