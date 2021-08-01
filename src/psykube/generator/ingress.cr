class Psykube::Generator::Ingress < ::Psykube::Generator
  cast_manifest Manifest::Serviceable

  protected def result
    Pyrite::Api::Extensions::V1beta1::Ingress.new(
      metadata: generate_metadata(annotations: [cluster_ingress_annotations]),
      spec: Pyrite::Api::Extensions::V1beta1::IngressSpec.new(
        rules: generate_rules,
        tls: generate_tls
      )
    ) if manifest.services? && ingress?
  end

  private def ingress?
    !!(manifest.ingress || cluster.ingress)
  end

  private def cluster_ingress
    cluster.ingress || Manifest::Ingress.new
  end

  private def cluster_ingress_annotations
    sets = [
      acme? ? {"kubernetes.io/tls-acme" => "true"} : nil,
      manifest_ingress.annotations,
      cluster_ingress.annotations,
    ].compact
    sets.reduce { |p, n| p.merge n } unless sets.empty?
  end

  private def manifest_ingress
    manifest.ingress || Manifest::Ingress.new
  end

  private def cluster_tls
    case cluster_ingress.tls
    when .nil?
      manifest_ingress.tls
    else
      cluster_ingress.tls
    end
  end

  private def acme?
    return true if cluster_tls == true
    if cluster_tls.is_a? Manifest::Ingress::Tls
      return true if cluster_tls.as(Manifest::Ingress::Tls).auto
    else
      false
    end
  end

  private def cluster_hosts
    manifest_ingress.hosts.merge cluster_ingress.hosts
  end

  private def generate_tls
    tls_list = cluster_hosts.compact_map do |host, spec|
      tls = spec.tls || cluster_tls
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
      Pyrite::Api::Extensions::V1beta1::IngressTLS.new(hosts: [host], secret_name: secret_name)
    end
  end

  private def generate_host_tls(host : String, auto : Bool)
    generate_host_tls_auto(host, auto) if auto
  end

  private def generate_host_tls_auto(host : String, auto : Manifest::Ingress::Tls::Auto)
    secret_name = "cert-" + auto.prefix.to_s + Digest::SHA1.hexdigest(host.downcase) + auto.suffix.to_s
    Pyrite::Api::Extensions::V1beta1::IngressTLS.new(hosts: [host], secret_name: secret_name)
  end

  private def generate_host_tls_auto(host : String, auto : Bool)
    secret_name = "cert-" + Digest::SHA1.hexdigest(host.downcase)
    Pyrite::Api::Extensions::V1beta1::IngressTLS.new(hosts: [host], secret_name: secret_name)
  end

  private def generate_rules
    rules = cluster_hosts.map do |host, spec|
      generate_host_paths(host, spec.paths)
    end
    rules.empty? ? nil : rules
  end

  private def generate_host_paths(host, paths : Manifest::Ingress::Host::PathMap)
    Pyrite::Api::Extensions::V1beta1::IngressRule.new(
      host: host,
      http: Pyrite::Api::Extensions::V1beta1::HTTPIngressRuleValue.new(
        paths: paths.map do |path, path_spec|
          Pyrite::Api::Extensions::V1beta1::HTTPIngressPath.new(
            path: path,
            backend: Pyrite::Api::Extensions::V1beta1::IngressBackend.new(
              service_name: generate_service_name(path_spec.service_name),
              service_port: get_service_port(path_spec.service_name, path_spec.port)
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
    return nil unless (service = get_service(service_name))
    get_service_port(service, port)
  rescue e : Manifest::PortError
    raise Manifest::PortError.new "#{service_name || "default"} service: {e.message}"
  end

  private def get_service_port(service : Manifest::Service, port : String | Int32 | Nil)
    service_ports = service.ports
    return lookup_port!(port) if !service_ports
    port ||= get_first_service_port(service) || lookup_port!(port)
    unless service_ports.includes?(port) || service_ports.includes?(lookup_port(port))
      raise Manifest::PortError.new "Port #{port.inspect} does not exist"
    end
  end

  private def get_first_service_port(service : Manifest::Service)
    case (service_ports = service.ports)
    when Hash(String, Int32 | String)
      service_ports.values.first?
    when Array(Int32 | String | Pyrite::Api::Core::V1::ServicePort)
      unless (port = service_ports.first?).is_a? Pyrite::Api::Core::V1::ServicePort
        port
      end
    end
  end

  private def get_service(service_name : String | Nil)
    case (services = manifest.services)
    when Hash(String, String | Manifest::Service)
      return nil if services.empty? && (!service_name || service_name == "default")
      unless (service = service_name ? services[service_name]? : services["default"]? || services.values.first?)
        raise Psykube::Error.new "Service #{service_name} does not exist in manifest (in get_service)"
      end
      return service if service.is_a? Manifest::Service
    else
      nil
    end
  end
end
