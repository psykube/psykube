require "../kubernetes/service"

class Psykube::Generator
  class Service < Generator
    protected def result
      if (service = manifest.service)
        Kubernetes::Service.new(manifest.name, manifest.ports).tap do |svc|
          svc.metadata.namespace = namespace
          svc.metadata.annotations = service.annotations
          if (spec = svc.spec)
            spec.type = service.type
            spec.cluster_ip = service.cluster_ip
            spec.load_balancer_ip = service.load_balancer_ip
            spec.load_balancer_source_ranges = service.load_balancer_source_ranges
            spec.session_affinity = service.session_affinity
            spec.external_ips = service.external_ips
          end
        end
      end
    end
  end
end
