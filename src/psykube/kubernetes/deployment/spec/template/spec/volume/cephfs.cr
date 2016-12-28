require "yaml"

class Psykube::Kubernetes::Deployment::Spec::Template::Spec::Volume
  class Cephfs
    Kubernetes.mapping({
      monitors:    Array(String),
      path:        String,
      user:        String,
      keyring:     String,
      secret_file: String,
      secret_ref:  SecretRef,
      read_only:   Bool | Nil,
    })
  end
end

require "./shared/secret_ref"
