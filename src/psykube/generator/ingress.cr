require "../kubernetes/ingress"

abstract class Psykube::Generator
  class Ingress < Generator
    protected def result
      Kubernetes::Ingress.new(manifest.name).tap do |ingress|
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
      end if manifest.service? && ingress?
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
        if tls = spec.tls || cluster_tls
          tls_list << generate_host_tls(host, tls).as(Kubernetes::Ingress::Spec::Tls)
        end
      end
      tls_list unless tls_list.empty?
    end

    private def generate_host_tls(host : String, tls : Manifest::Ingress::Tls)
      Kubernetes::Ingress::Spec::Tls.new(host, tls.secret_name)
    end

    private def generate_host_tls(host : String, tls : Nil)
    end

    private def generate_host_tls(host : String, tls : Bool)
      if tls
        Kubernetes::Ingress::Spec::Tls.new(host)
      end
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
          path, manifest.name, lookup_port(path_spec.port)
        )
      end
      rules << Kubernetes::Ingress::Spec::Rule.new(host, kube_paths)
      rules
    end
  end
end
