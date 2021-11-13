class Psykube::Generator::CRDS < ::Psykube::Generator
  private def combined_crds
    manifest_crds.merge cluster_crds
  end

  private def manifest_crds
    manifest.crds || {} of String => String
  end

  private def cluster_crds
    cluster.crds || {} of String => String
  end
end
  