require "../kubernetes/service"

class Psykube::Generator
  class Service < Generator
    protected def result
      if manifest.service
        Kubernetes::Service.new(manifest.name, manifest.ports)
      end
    end
  end
end
