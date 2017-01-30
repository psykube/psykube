require "../kubernetes/secret"

class Psykube::Generator
  class Secret < Generator
    protected def result
      unless combined_secrets.empty?
        Kubernetes::Secret.new(manifest.name, combined_secrets).tap do |secret|
          secret.metadata.namespace = namespace
        end
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
