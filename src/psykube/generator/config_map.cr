class Psykube::Generator::ConfigMap < ::Psykube::Generator
  protected def result
    unless combined_config_map.empty?
      Pyrite::Api::Core::V1::ConfigMap.new(
        metadata: generate_metadata,
        data: combined_config_map
      )
    end
  end

  private def combined_config_map
    manifest_config_map.merge cluster_config_map
  end

  private def manifest_config_map
    manifest.config_map || {} of String => String
  end

  private def cluster_config_map
    cluster.config_map || {} of String => String
  end
end
