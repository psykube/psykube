class Psykube::Generator::Ingress < ::Psykube::Generator
  cast_manifest Manifest::Serviceable

  protected def result
    Pyrite::Api::Networking::V1::Ingress.new(
      metadata: generate_metadata(annotations: [cluster_ingress_annotations]),
      spec: Pyrite::Api::Networking::V1::IngressSpec.new(
        rules: generate_rules,
        tls: generate_tls
      )
    ) if manifest.services? && ingress?
  end

  private def ingress?
    !!(manifest.ingress || cluster.ingress)
  end

  private def cluster_ingress_annotations
    sets = [
      acme? ? {"kubernetes.io/tls-acme" => "true"} : nil,
      ingress.annotations,
    ].compact
    sets.reduce { |p, n| p.merge n } unless sets.empty?
  end

  private def acme?
    !!ingress.tls
  end

  private def ingress
    (manifest.ingress || Manifest::Ingress.new).merge(cluster.ingress || Manifest::Ingress.new)
  end

  private def generate_tls
    tls_list = ingress.hosts.compact_map do |host, spec|
      tls = spec.tls
      generate_host_tls(host, tls) if tls
    end
    tls_list unless tls_list.empty?
  end

  private def generate_host_tls(host : String, tls : Manifest::Ingress::Tls)
    raise Psykube::Error.new "Cannot assign automatic TLS with a static secret name." if tls.auto && tls.secret_name
    if (auto = tls.auto)
      return generate_host_tls_auto host, auto
    end
    if (secret_name = tls.secret_name)
      Pyrite::Api::Networking::V1::IngressTLS.new(hosts: [host], secret_name: secret_name)
    end
  end

  private def generate_host_tls(host : String, auto : Bool)
    generate_host_tls_auto(host, auto) if auto
  end

  private def generate_host_tls_auto(host : String, auto : Manifest::Ingress::Tls::Auto)
    secret_name = "cert-" + auto.prefix.to_s + Digest::SHA1.hexdigest(host.downcase) + auto.suffix.to_s
    Pyrite::Api::Networking::V1::IngressTLS.new(hosts: [host], secret_name: secret_name)
  end

  private def generate_host_tls_auto(host : String, auto : Bool)
    secret_name = "cert-" + Digest::SHA1.hexdigest(host.downcase)
    Pyrite::Api::Networking::V1::IngressTLS.new(hosts: [host], secret_name: secret_name)
  end

  private def generate_rules
    rules = ingress.hosts.map do |host, spec|
      generate_host_paths(host, spec.paths)
    end
    rules.empty? ? nil : rules
  end

  private def generate_host_paths(host, paths : Manifest::Ingress::Host::PathMap)
    Pyrite::Api::Networking::V1::IngressRule.new(
      host: host,
      http: Pyrite::Api::Networking::V1::HTTPIngressRuleValue.new(
        paths: paths.map do |path, path_spec|
          Pyrite::Api::Networking::V1::HTTPIngressPath.new(
            path_type: "Prefix",
            path: path.to_s == "" ? "/" : path,
            backend: Pyrite::Api::Networking::V1::IngressBackend.new(
              service: Pyrite::Api::Networking::V1::IngressServiceBackend.new(
                name: generate_service_name(path_spec.service_name),
                port: Pyrite::Api::Networking::V1::ServiceBackendPort.new(
                  number: get_service_port(path_spec.service_name, path_spec.port)
                )
              )
            )
          )
        end
      )
    )
  end

  private def generate_service_name(_nil : Nil)
    return name unless (services = manifest.services)
    case (services = manifest.services)
    when Hash(String, String | Manifest::Service)
      generate_service_name(services.keys.first? || "default")
    else
      name
    end
  end

  private def generate_service_name(service_name : String)
    case (services = manifest.services)
    when Hash(String, String | Manifest::Service)
      raise Psykube::Error.new "Service #{service_name.inspect} does not exist in manifest" unless services.keys.includes? service_name
    when Array(String)
      raise Psykube::Error.new "Service #{service_name.inspect} does not exist in manifest" unless services.includes? service_name
    when Nil
      raise Psykube::Error.new "Service #{service_name.inspect} does not exist in manifest" unless service_name === "default"
    end
    service_name == "default" ? name : [name, service_name].compact.join("-")
  end

  private def get_service_port(service_name : String | Nil, port : String | Int32 | Nil)
    return lookup_port!(port) unless (service = get_service(service_name))
    get_service_port(service, port)
  rescue e : Manifest::PortError
    raise Manifest::PortError.new "#{service_name || "default"} service: {e.message}"
  end

  private def get_service_port(service : Manifest::Service, port : Int32 | Nil) : Int32
    return lookup_port!(port) if !service.ports
    port ||= get_first_service_port(service)
    unless extract_service_ports(service).includes? port
      raise Manifest::PortError.new "Port #{port.inspect} does not exist"
    end
    port
  end

  private def get_service_port(service : Manifest::Service, port_name : String) : Int32
    case (service_ports = service.ports)
    when Hash(String, Int32 | String)
      parse_service_port service_ports[port_name]? || raise Psykube::Error.new("No port named #{port_name} in service")
    when Nil
      lookup_port! port_name
    else
      raise Psykube::Error.new("port not found in service")
    end
  end

  private def get_first_service_port(service : Manifest::Service) : Int32
    extract_service_ports(service).first?.tap do |port|
      raise Psykube::Error.new("Service has no ports") unless port
    end.not_nil!
  end

  private def get_service(service_name : String | Nil)
    case (services = manifest.services)
    when Hash(String, String | Manifest::Service)
      return nil if services.empty? && (!service_name || service_name == "default")
      unless (service = service_name ? services[service_name]? : services["default"]? || services.values.first?)
        raise Psykube::Error.new "Service #{service_name} does not exist in manifest"
      end
      return service if service.is_a? Manifest::Service
    else
      nil
    end
  end

  private def parse_service_port(port : String | Int32 | Pyrite::Api::Core::V1::ServicePort) : Int32
    case port
    when Int32
      port
    when String
      parts = port.split(':', 2)
      source_port = parts.size == 2 ? parts[0].to_i? : lookup_port!(parts[0])
      raise Psykube::Error.new("port must be an integer greater than zero") unless source_port.try(&.> 0)
      source_port.not_nil!
    when Pyrite::Api::Core::V1::ServicePort
      port.port
    end.not_nil!
  end

  private def extract_service_ports(service : Manifest::Service)
    case (service_ports = service.ports)
    when Hash(String, Int32 | String)
      service_ports.values.compact_map { |p| parse_service_port p }.uniq!
    when Array(Int32 | String | Pyrite::Api::Core::V1::ServicePort)
      service_ports.compact_map { |p| parse_service_port p }.uniq!
    else
      ports.values || [] of Int32
    end
  end
end
