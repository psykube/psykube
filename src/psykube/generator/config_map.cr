require "../kubernetes/config_map"

abstract class Psykube::Generator
  class ConfigMap < Generator
    protected def result
      unless combined_config_map.empty?
        Kubernetes::ConfigMap.new(name, combined_config_map).tap do |config_map|
          assign_labels(config_map, manifest)
          assign_labels(config_map, cluster_manifest)
          config_map.metadata.namespace = namespace
        end
      end
    end

    private def combined_config_map
      manifest_config_map.merge cluster_config_map
    end

    private def manifest_config_map
      manifest.config_map || {} of String => String
    end

    private def cluster_config_map
      cluster_manifest.config_map || {} of String => String
    end
  end
end
