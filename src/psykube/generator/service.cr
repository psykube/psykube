require "../kubernetes/service"

class Psykube::Generator
  module Service
    @service : Psykube::Kubernetes::Service
    getter service

    private def generate_service
      Psykube::Kubernetes::Service.new(manifest.name, manifest.ports)
    end
  end
end
