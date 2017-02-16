require "../kubernetes/service"

class Psykube::Generator
  class Service < Generator
    protected def result
      if manifest.service?
        Kubernetes::Service.new(manifest.name, manifest.ports).tap do |service|
          service.metadata.namespace = namespace
        end
      end
    end
  end
end
