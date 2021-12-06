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
        ports: generate_ports(service.ports || manifest.ports),
        publish_not_ready_addresses: service.publish_not_ready_addresses,
      )
    )
  end

  private def generate_ports(ports : Hash(String, Int32 | String))
    ports.map do |name, port|
      generate_port(name, port)
    end
  end

  private def generate_ports(ports : Array(Int32 | String | Pyrite::Api::Core::V1::ServicePort))
    ports.map do |port|
      generate_port(port)
    end
  end

  private def generate_port(name : String?, port : String)
    parts = port.split(':', 2)
    target_port = parts.size == 2 ? lookup_port!(parts[1]) : lookup_port!(parts[0])
    source_port = parts.size == 2 ? parts[0].to_i? : target_port
    raise Psykube::Error.new("target_port must be an integer greater than zero") unless target_port.try(&.> 0)
    raise Psykube::Error.new("source_port must be an integer greater than zero") unless source_port.try(&.> 0)
    name ||= if parts.size == 2 && parts[1].to_i? != target_port
               parts[1]
             elsif parts.size == 1 && parts[0].to_i? != source_port
               parts[0]
             else
               self.name
             end
    Pyrite::Api::Core::V1::ServicePort.new(
      name: name,
      port: source_port.not_nil!,
      target_port: lookup_port!(target_port).not_nil!,
      protocol: "TCP"
    )
  end

  private def generate_port(name : String?, port : Int32)
    Pyrite::Api::Core::V1::ServicePort.new(
      name: name || self.name,
      port: port,
      target_port: lookup_port!(port),
      protocol: "TCP"
    )
  end

  private def generate_port(port : String | Int32)
    generate_port nil, port
  end

  private def generate_port(port : Pyrite::Api::Core::V1::ServicePort)
    port
  end
end
