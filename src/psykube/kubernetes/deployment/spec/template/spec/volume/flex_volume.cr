require "../../../../concerns/mapping"

class Psykube::Kubernetes::Deployment::Spec::Template::Spec::Volume
  class FlexVolume
    Kubernetes.mapping({
      driver:     String,
      fs_type:    String,
      secret_ref: SecretRef,
      read_only:  Bool | Nil,
      options:    Hash(String, String) | Nil,
    })
  end
end

require "./shared/secret_ref"
