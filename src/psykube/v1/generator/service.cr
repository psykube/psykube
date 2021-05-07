class Psykube::V1::Generator::Service < ::Psykube::Generator
  include Concerns::PodHelper
  cast_manifest Manifest

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
          ports: generate_ports(service.ports || manifest.ports)
        )
      )
    end
  end

  private def generate_ports(ports : Hash(String, Int32 | String))
    ports.map do |name, port|
      generate_port(name, port)
    end
  end

  private def generate_ports(ports : Array(String | Pyrite::Api::Core::V1::ServicePort))
    ports.map do |port|
      generate_port(port)
    end
  end

  private def generate_port(name, port)
    Pyrite::Api::Core::V1::ServicePort.new(
      name: name,
      port: lookup_port(port),
      protocol: "TCP"
    )
  end

  private def generate_port(port : String)
    parts = port.split(":")
    source_port = parts[0]
    target_port = parts[1]?
    Pyrite::Api::Core::V1::ServicePort.new(
      name: name,
      port: lookup_port(source_port),
      target_port: lookup_port(target_port),
      protocol: "TCP"
    )
  end

  private def generate_port(port : Pyrite::Api::Core::V1::ServicePort)
    port
  end
end
