require "../../../../concerns/mapping"

class Psykube::Kubernetes::Deployment::Spec::Template::Spec::Volume
  class Rbd
    Kubernetes.mapping({
      monitors:   {type: Array(String)},
      image:      String,
      fs_type:    {type: String, key: "fsType"},
      pool:       String,
      user:       String,
      keyring:    String,
      secret_ref: {type: SecretRef, key: "secretRef"},
      read_only:  {type: Bool, nilable: true, key: "readOnly"},
    })
  end
end

require "./shared/secret_ref"
