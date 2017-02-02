require "../kubernetes/secret"

class Psykube::Generator
  class Secret < Generator
    protected def result
      unless combined_secrets.empty?
        Kubernetes::Secret.new(manifest.name, encoded_secrets).tap do |secret|
          secret.metadata.namespace = namespace
        end
      end
    end

    private def encoded_secrets
      combined_secrets.each_with_object({} of String => String) do |(k, v), hash|
        hash[k] = Base64.encode(v)
      end
    end

    private def combined_secrets
      manifest_secrets.merge(cluster_secrets)
    end

    private def manifest_secrets
      manifest.secrets || {} of String => String
    end

    private def cluster_secrets
      cluster_manifest.secrets || {} of String => String
    end
  end
end
