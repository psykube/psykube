require "../kubernetes/service"

class Psykube::Generator
  module Service
    @service : Psykube::Kubernetes::Service | Nil
    getter service

    private def generate_service
      if manifest.service
        Psykube::Kubernetes::Service.new(manifest.name, manifest.ports)
      end
    end
  end
end
