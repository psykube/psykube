class Psykube::V2::Generator::Ingress < ::Psykube::Generator
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
    cluster.ingress || V1::Manifest::Ingress.new
  end

  private def cluster_ingress_annotations
    sets = [
      {"kubernetes.io/tls-acme" => acme?.to_s},
      manifest_ingress.annotations,
      cluster_ingress.annotations,
    ].compact
    sets.reduce { |p, n| p.merge n }
  end

  private def manifest_ingress
    manifest.ingress || V1::Manifest::Ingress.new
  end

  private def cluster_tls
    cluster_ingress.tls || manifest_ingress.tls
  end

  private def acme?
    return true if cluster_tls == true
    if cluster_tls.is_a? V1::Manifest::Ingress::Tls
      return true if cluster_tls.as(V1::Manifest::Ingress::Tls).auto
    else
      false
    end
  end

  private def cluster_hosts
    manifest_ingress.hosts.merge cluster_ingress.hosts
  end

  private def generate_tls
    tls_list = cluster_hosts.map do |host, spec|
      tls = spec.tls || cluster_tls
      tls_record = generate_host_tls(host, tls) if tls
    end.compact
    tls_list unless tls_list.empty?
  end

  private def generate_host_tls(host : String, tls : V1::Manifest::Ingress::Tls)
    raise "Cannot assign automatic TLS with a static secret name." if tls.auto && tls.secret_name
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

  private def generate_host_tls_auto(host : String, auto : V1::Manifest::Ingress::Tls::Auto)
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

  private def generate_host_paths(host, paths : V1::Manifest::Ingress::Host::PathMap)
    Pyrite::Api::Extensions::V1beta1::IngressRule.new(
      host: host,
      http: Pyrite::Api::Extensions::V1beta1::HTTPIngressRuleValue.new(
        paths: paths.map do |path, path_spec|
          Pyrite::Api::Extensions::V1beta1::HTTPIngressPath.new(
            path: path,
            backend: Pyrite::Api::Extensions::V1beta1::IngressBackend.new(
              service_name: name,
              service_port: lookup_port(path_spec.port)
            )
          )
        end
      )
    )
  end
end
