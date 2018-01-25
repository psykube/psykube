abstract class Psykube::Generator
  class Container < Generator
    @resource : Pyrite::Kubernetes::Resource?

    protected def result
      return unless (cluster_container = self.cluster_container)
      Pyrite::Api::Core::V1::Container.new(
        metadata: generate_metadata,
        name: cluster_container.name,
        image:
        command:
        args:
        # env?
      )
    end

    protected def cluster_container
      mic = manifest.init_container
      cic = cluster_manifest.init_container
      if mic && cic
        mic.merge cic
      elsif cic
        cic
      elsif mic
        mic
      end
    end
  end
end
