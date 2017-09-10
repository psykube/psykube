abstract class Psykube::Generator
  class Autoscale < Generator
    @resource : Kubernetes::Resource?

    protected def result
      return unless (cluster_autoscale = self.cluster_autoscale)
      Kubernetes::Apis::Autoscaling::V1::HorizontalPodAutoscaler.new(
        metadata: generate_metadata,
        spec: Kubernetes::Apis::Autoscaling::V1::HorizontalPodAutoscalerSpec.new(
          min_replicas: cluster_autoscale.min,
          max_replicas: cluster_autoscale.max,
          target_cpu_utilization_percentage: cluster_autoscale.target_cpu_percentage,
          scale_target_ref: Kubernetes::Apis::Autoscaling::V1::CrossVersionObjectReference.new(
            api_version: resource.api_version,
            kind: resource.kind,
            name: resource.metadata.not_nil!.name.not_nil!
          )
        )
      )
    end

    private def resource
      @resource ||= case manifest.type
                    when "Deployment"
                      Deployment.result(self)
                    when "ReplicationController"
                      ReplicationController.result(self)
                    when "ReplicaSet"
                      ReplicaSet.result(self)
                    else
                      raise "Invalid type for autoscale: `#{manifest.type}`"
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
