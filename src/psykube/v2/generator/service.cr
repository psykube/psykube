class Psykube::V2::Generator::Service < ::Psykube::Generator
  include Concerns::PodHelper
  cast_manifest Manifest::Serviceable

  def result
    generate_service
  end

  private def generate_service
    generate_service manifest.service
  end

  private def generate_service(service : V1::Manifest::Service)
    return unless manifest.ports?
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

  private def generate_service(service_type : String)
    return unless manifest.ports?
    Pyrite::Api::Core::V1::Service.new(
      metadata: generate_metadata(labels: [{"service" => name}]),
      spec: Pyrite::Api::Core::V1::ServiceSpec.new(
        selector: generate_selector.match_labels,
        type: service_type,
        ports: generate_ports
      )
    )
  end

  private def generate_service(has_service : Bool)
    return unless has_service
    generate_service "ClusterIP"
  end

  private def generate_service(null : Nil)
    generate_service "ClusterIP"
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
