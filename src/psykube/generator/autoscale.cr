require "../kubernetes/horizontal_pod_autoscaler"

abstract class Psykube::Generator
  class Autoscale < Generator
    protected def result
      return unless (cluster_autoscale = self.cluster_autoscale)
      return unless (api = self.api)
      Kubernetes::HorizontalPodAutoscaler.new(
        api,
        manifest.type,
        name,
        cluster_autoscale.min,
        cluster_autoscale.max
      ).tap do |autoscale|
        autoscale.metadata.namespace = namespace
        if (spec = autoscale.spec)
          spec.target_cpu_utilization_percentage = cluster_autoscale.target_cpu_percentage
        end
      end
    end

    protected def api
      case manifest.type
      when "Deployment", "ReplicaSet"
        "extensions/v1beta1"
      when "ReplicationController"
        "v1"
      end
    end

    protected def cluster_autoscale
      mas = manifest.autoscale
      cas = cluster_manifest.autoscale
      if mas && cas
        mas.merge cas
      elsif cas
        cas
      elsif mas
        mas
      end
    end
  end
end
