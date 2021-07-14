class Psykube::Generator::Service < ::Psykube::Generator
  include Concerns::PodHelper
  cast_manifest Manifest::Serviceable

  protected def result
    return [] of Pyrite::Api::Core::V1::Service unless manifest.ports? && (services = manifest.services)
    generate_services services
  end

  private def generate_services(_nil : Nil)
    [] of Pyrite::Api::Core::V1::Service
  end

  private def generate_services(service : String)
    [generate_service(nil, service)]
  end

  private def generate_services(services : Array(String))
    services.map do |service|
      generate_service service
    end
  end

  private def generate_services(services : Hash(String, String | Manifest::Service))
    services.map do |name, service|
      generate_service name, service
    end
  end

  private def generate_service(service_type : String)
    generate_service(service_type.downcase, service_type)
  end

  private def generate_service(name : String?, service_type : String)
    generate_service name, Manifest::Service.new(service_type)
  end

  private def generate_service(name : String?, service : Manifest::Service)
    name = nil if name == "default"
    Pyrite::Api::Core::V1::Service.new(
      metadata: generate_metadata(name: [self.name, name].compact.join('-'), annotations: [service.annotations]),
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
