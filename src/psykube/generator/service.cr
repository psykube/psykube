class Psykube::Generator
  module Service
    private def generate_service
      Psykube::Kubernetes::Service.new(manifest.name, manifest.ports)
    end
  end
end
