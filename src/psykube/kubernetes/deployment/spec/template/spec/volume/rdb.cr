require "../../../../concerns/mapping"

class Psykube::Kubernetes::Deployment::Spec::Template::Spec::Volume
  class Rbd
    Kubernetes.mapping({
      monitors:   Array(String),
      image:      String,
      fs_type:    String,
      pool:       String,
      user:       String,
      keyring:    String,
      secret_ref: SecretRef,
      read_only:  Bool | Nil,
    })
  end
end

require "./shared/secret_ref"
