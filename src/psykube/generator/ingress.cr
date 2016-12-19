require "../kubernetes/ingress"

class Psykube::Generator
  module Ingress
    @ingress : Psykube::Kubernetes::Ingress
    getter ingress

    private def generate_ingress
      Psykube::Kubernetes::Ingress.new.tap do |ingress|
        ingress.spec.rules = [] of Psykube::Kubernetes::Ingress::Spec::Rule
        ingress.spec.tls = generate_ingress_tls_from_manifest(cluster_manifest.ingress)
        ingress.spec.rules = generate_ingress_rules_from_manifest(cluster_manifest.ingress)
      end
    end

    private def generate_ingress_tls_from_manifest(cluster_ingress : Nil)
    end

    private def generate_ingress_rules_from_manifest(cluster_ingress : Nil)
    end

    private def generate_ingress_tls_from_manifest(cluster_ingress : Psykube::Manifest::Cluster::Ingress)
      tls = [] of Psykube::Kubernetes::Ingress::Spec::Tls
      cluster_ingress.hosts.each do |host, spec|
        tls.push(Psykube::Kubernetes::Ingress::Spec::Tls.new(host)) if spec.tls
      end
      tls
    end

    private def generate_ingress_rules_from_manifest(cluster_ingress : Psykube::Manifest::Cluster::Ingress)
      rules = [] of Psykube::Kubernetes::Ingress::Spec::Rule
      cluster_ingress.hosts.map do |host, spec|
        rules += generate_ingress_paths(host, spec.paths)
      end
      rules.empty? ? nil : rules
    end

    private def generate_ingress_paths(host, paths : Psykube::Manifest::Cluster::Ingress::Host::PathStrings)
      name_map = Psykube::Manifest::Cluster::Ingress::Host::PathPortMap.new
      paths.each do |path|
        name_map[path] = "default".as(String)
      end
      generate_ingress_paths(host, name_map)
    end

    private def generate_ingress_paths(host, paths : Psykube::Manifest::Cluster::Ingress::Host::PathPortMap)
      rules = [] of Psykube::Kubernetes::Ingress::Spec::Rule
      kube_paths = paths.map do |path, port_or_name|
        if port_or_name.to_u16?
          generate_ingress_path(path, port_or_name.to_u16)
        else
          generate_ingress_path(path, port_or_name)
        end
      end
      rules << Psykube::Kubernetes::Ingress::Spec::Rule.new(host, kube_paths)
      rules
    end

    private def generate_ingress_path(path : String, port_name : String)
      generate_ingress_path(path, manifest.ports[port_name])
    end

    private def generate_ingress_path(path : String, port : UInt16)
      Psykube::Kubernetes::Ingress::Spec::Rule::Http::Path.new(
        path, manifest.name, port
      )
    end

  end
end
