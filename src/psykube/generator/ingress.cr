require "../kubernetes/ingress"

class Psykube::Generator
  module Ingress
    @ingress : Kubernetes::Ingress | Nil
    getter ingress

    private def generate_ingress
      Kubernetes::Ingress.new(name).tap do |ingress|
        ingress.metadata.annotations = cluster_ingress_annotations unless cluster_ingress_annotations.empty?
        ingress.spec.rules = [] of Kubernetes::Ingress::Spec::Rule
        ingress.spec.tls = generate_ingress_tls
        ingress.spec.rules = generate_ingress_rules
      end if manifest.service && cluster_manifest.ingress
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
      manifest_ingress.tls || cluster_manifest_ingress.tls
    end

    private def cluster_ingress_hosts
      (manifest_ingress.hosts || {} of String => Manifest::Ingress::Host).merge(
        cluster_manifest_ingress.hosts || {} of String => Manifest::Ingress::Host
      )
    end

    private def generate_ingress_tls
      ([] of Kubernetes::Ingress::Spec::Tls).tap do |tls|
        cluster_ingress_hosts.each do |host, spec|
          if spec.tls
            tls.push generate_ingress_tls_host(host, spec.tls).as(Kubernetes::Ingress::Spec::Tls)
          end
        end
      end
    end

    private def generate_ingress_tls_host(host : String, tls : Manifest::Ingress::Host::Tls)
      Kubernetes::Ingress::Spec::Tls.new(host, tls.secret_name)
    end

    private def generate_ingress_tls_host(host : String, tls : Nil)
    end

    private def generate_ingress_tls_host(host : String, tls : Bool)
      Kubernetes::Ingress::Spec::Tls.new(host)
    end

    private def generate_ingress_rules
      rules = [] of Kubernetes::Ingress::Spec::Rule
      cluster_ingress_hosts.map do |host, spec|
        rules += generate_ingress_paths(host, spec.paths)
      end
      rules.empty? ? nil : rules
    end

    private def generate_ingress_paths(host, paths : Manifest::Ingress::Host::PathStrings)
      name_map = Manifest::Ingress::Host::PathPortMap.new
      paths.each do |path|
        name_map[path] = "default".as(String)
      end
      generate_ingress_paths(host, name_map)
    end

    private def generate_ingress_paths(host, paths : Manifest::Ingress::Host::PathPortMap)
      rules = [] of Kubernetes::Ingress::Spec::Rule
      kube_paths = paths.map do |path, port_or_name|
        Kubernetes::Ingress::Spec::Rule::Http::Path.new(
          path, manifest.name, lookup_port(port_or_name)
        )
      end
      rules << Kubernetes::Ingress::Spec::Rule.new(host, kube_paths)
      rules
    end
  end
end
