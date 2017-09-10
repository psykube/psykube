abstract class Psykube::Generator
  class Service < Generator
    protected def result
      if (service = manifest.service)
        Kubernetes::Api::V1::Service.new(
          metadata: generate_metadata(annotations: [service.annotations]),
          spec: Kubernetes::Api::V1::ServiceSpec.new(
            type: service.type,
            cluster_ip: service.cluster_ip,
            load_balancer_ip: service.load_balancer_ip,
            load_balancer_source_ranges: service.load_balancer_source_ranges,
            session_affinity: service.session_affinity,
            external_ips: service.external_ips,
            ports: generate_ports
          )
        )
      end
    end

    private def generate_ports
      manifest.ports.map do |name, port|
        Kubernetes::Api::V1::ServicePort.new(
          name: name,
          port: port
        )
      end
    end
  end
end
