require "../kubernetes/horizontal_pod_autoscaler"

class Psykube::Generator
  class Autoscale < Generator
    protected def result
      if autoscale?
        Kubernetes::HorizontalPodAutoscaler.new(
          "extensions/v1beta1",
          "Deployment",
          manifest.name,
          cluster_autoscale.min,
          cluster_autoscale.max
        ).tap do |autoscale|
          autoscale.metadata.namespace = namespace
        end
      end
    end

    private def autoscale?
      !!(cluster_manifest.autoscale || manifest.autoscale)
    end

    private def cluster_autoscale
      cluster_manifest.autoscale || manifest.autoscale || Manifest::Autoscale.new
    end
  end
end
