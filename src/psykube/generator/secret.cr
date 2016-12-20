require "../kubernetes/secret"

class Psykube::Generator
  module Secret
    @secret : Psykube::Kubernetes::Secret
    getter secret

    private def generate_secret
      combined_secrets = manifest.secrets.merge(
        cluster_manifest.secrets
      )
      Psykube::Kubernetes::Secret.new(
        cluster_name,
        combined_secrets
      )
    end
  end
end
