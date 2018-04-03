class Psykube::V2::Generator::Service < ::Psykube::Generator
  include Concerns::PodHelper
  cast_manifest Manifest::Serviceable

  protected def result
    if manifest.ports? && (services = manifest.services)
      generate_services services
    end
  end

  private def generate_services(service : String)
    [generate_service(nil, service)]
  end

  private def generate_services(services : Array(String))
    services.map do |service|
      generate_service service
    end
  end

  private def generate_services(services : Hash(String, String | V1::Manifest::Service))
    services.map do |name, service|
      generate_service name, service
    end
  end

  private def generate_service(service_type : String)
    generate_service(service_type.downcase, service_type)
  end

  private def generate_service(name : String?, service_type : String)
    generate_service name, V1::Manifest::Service.new(service_type)
  end

  private def generate_service(name : String?, service : V1::Manifest::Service)
    Pyrite::Api::Core::V1::Service.new(
      metadata: generate_metadata(labels: [{"service" => [self.name, name].compact.join('-')}], annotations: [service.annotations]),
      spec: Pyrite::Api::Core::V1::ServiceSpec.new(
        selector: generate_selector.match_labels,
        type: service.type,
        cluster_ip: service.cluster_ip,
        load_balancer_ip: service.load_balancer_ip,
        load_balancer_source_ranges: service.load_balancer_source_ranges,
        session_affinity: service.session_affinity,
        external_ips: service.external_ips,
        ports: generate_ports(service.ports)
      )
    )
  end

  private def generate_ports(ports : Nil)
    manifest.ports.map do |name, port|
      Pyrite::Api::Core::V1::ServicePort.new(
        name: name,
        port: port,
        protocol: "TCP"
      )
    end
  end

  private def generate_ports(ports : Hash(String, Int32))
    ports.map do |name, port|
      Pyrite::Api::Core::V1::ServicePort.new(
        name: name,
        port: port,
        protocol: "TCP"
      )
    end
  end
end
