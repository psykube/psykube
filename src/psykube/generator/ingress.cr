require "../kubernetes/ingress"

abstract class Psykube::Generator
  class Ingress < Generator
    protected def result
      Kubernetes::Ingress.new(name).tap do |ingress|
        assign_labels(ingress, manifest)
        assign_labels(ingress, cluster_manifest)
        assign_annotations(ingress, {"kubernetes.io/tls-acme" => "true"}) if cluster_tls == true
        assign_annotations(ingress, manifest_ingress)
        assign_annotations(ingress, cluster_manifest_ingress)

        ingress.metadata.namespace = namespace

        ingress.spec = Kubernetes::Ingress::Spec.new.tap do |spec|
          spec.rules = [] of Kubernetes::Ingress::Spec::Rule
          spec.tls = generate_tls
          spec.rules = generate_rules
        end
      end if manifest.service && ingress?
    end

    private def ingress?
      !!(manifest.ingress || cluster_manifest.ingress)
    end

    private def cluster_manifest_ingress
      cluster_manifest.ingress || Manifest::Ingress.new
    end

    private def cluster_ingress_annotations
      (manifest_ingress.annotations || {} of String => String).merge(
        cluster_manifest_ingress.annotations || {} of String => String
      )
    end

    private def manifest_ingress
      manifest.ingress || Manifest::Ingress.new
    end

    private def cluster_tls
      [cluster_manifest_ingress.tls, manifest_ingress.tls].reject(&.nil?)[0]?
    end

    private def cluster_hosts
      manifest_ingress.hosts.merge cluster_manifest_ingress.hosts
    end

    private def generate_tls
      tls_list = [] of Kubernetes::Ingress::Spec::Tls
      cluster_hosts.each do |host, spec|
        tls = spec.tls || cluster_tls
        tls_record = generate_host_tls(host, tls) if tls
        tls_list << tls_record if tls_record
      end
      tls_list unless tls_list.empty?
    end

    private def generate_host_tls(host : String, tls : Manifest::Ingress::Tls)
      raise "Cannot assign automatic TLS with a static secret name." if tls.auto && tls.secret_name
      if (auto = tls.auto)
        return generate_host_tls_auto host, auto
      end
      if (secret_name = tls.secret_name)
        Kubernetes::Ingress::Spec::Tls.new(host, secret_name)
      end
    end

    private def generate_host_tls(host : String, auto : Bool)
      generate_host_tls(host, auto) if auto
    end

    private def generate_host_tls_auto(host : String, auto : Manifest::Ingress::Tls::Auto)
      Kubernetes::Ingress::Spec::Tls.new(host: host, prefix: auto.prefix.to_s, suffix: auto.suffix.to_s)
    end

    private def generate_host_tls_auto(host : String, auto : Bool)
      Kubernetes::Ingress::Spec::Tls.new(host)
    end

    private def generate_rules
      rules = [] of Kubernetes::Ingress::Spec::Rule
      cluster_hosts.map do |host, spec|
        rules += generate_host_paths(host, spec.paths)
      end
      rules.empty? ? nil : rules
    end

    private def generate_host_paths(host, paths : Manifest::Ingress::Host::PathMap)
      rules = [] of Kubernetes::Ingress::Spec::Rule
      kube_paths = paths.map do |path, path_spec|
        Kubernetes::Ingress::Spec::Rule::Http::Path.new(
          path, name, lookup_port(path_spec.port)
        )
      end
      rules << Kubernetes::Ingress::Spec::Rule.new(host, kube_paths)
      rules
    end
  end
end
