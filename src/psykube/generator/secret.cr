require "../kubernetes/secret"

class Psykube::Generator
  module Secret
    @secret : Psykube::Kubernetes::Secret | Nil
    getter secret

    private def generate_secret
      unless combined_secrets.empty?
        Psykube::Kubernetes::Secret.new(cluster_name, combined_secrets)
      end
    end

    private def combined_secrets
      manifest_secrets.merge cluster_secrets
    end

    private def manifest_secrets
      manifest.secrets || {} of String => String
    end

    private def cluster_secrets
      cluster_manifest.secrets || {} of String => String
    end
  end
end
