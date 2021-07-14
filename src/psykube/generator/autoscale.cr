class Psykube::Generator::Autoscale < ::Psykube::Generator
  @resource : Pyrite::Kubernetes::Resource?

  cast_manifest Manifest::Deployment

  protected def result
    return unless (cluster_autoscale = self.cluster_autoscale)
    Pyrite::Api::Autoscaling::V1::HorizontalPodAutoscaler.new(
      metadata: generate_metadata,
      spec: Pyrite::Api::Autoscaling::V1::HorizontalPodAutoscalerSpec.new(
        min_replicas: cluster_autoscale.min,
        max_replicas: cluster_autoscale.max,
        target_cpu_utilization_percentage: cluster_autoscale.target_cpu_percentage,
        scale_target_ref: Pyrite::Api::Autoscaling::V1::CrossVersionObjectReference.new(
          api_version: resource.api_version,
          kind: resource.kind,
          name: resource.metadata.not_nil!.name.not_nil!
        )
      )
    )
  end

  private def resource
    raise "Invalid type for autoscale: `#{manifest.type}`" unless manifest.type == "Deployment"
    @resource ||= Deployment.result(self)
  end

  protected def cluster_autoscale
    mas = manifest.autoscale
    cas = cluster.autoscale
    if mas && cas
      mas.merge cas
    elsif cas
      cas
    elsif mas
      mas
    end
  end
end
