class Psykube::V2::Generator::Service < ::Psykube::Generator
  include Concerns::PodHelper
  cast_manifest Manifest::Serviceable

  protected def result
    if (service = manifest.service)
      Pyrite::Api::Core::V1::Service.new(
        metadata: generate_metadata(labels: [{"service" => name}], annotations: [service.annotations]),
        spec: Pyrite::Api::Core::V1::ServiceSpec.new(
          selector: generate_selector.match_labels,
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
      Pyrite::Api::Core::V1::ServicePort.new(
        name: name,
        port: port,
        protocol: "TCP"
      )
    end
  end
end
