require "../../../concerns/mapping"

class Psykube::Kubernetes::Pod::Spec::Volume
  class Cephfs
    Kubernetes.mapping({
      monitors:    Array(String),
      path:        String,
      user:        String,
      keyring:     String,
      secret_file: String,
      secret_ref:  SecretRef,
      read_only:   Bool?,
    })
  end
end

require "./shared/secret_ref"
