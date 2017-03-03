require "../kubernetes/deployment"
require "../kubernetes/pod"
require "./concerns/*"

abstract class Psykube::Generator
  class Pod < Generator
    include Concerns::PodHelper

    protected def result
      Kubernetes::Pod.new(manifest.name).tap do |pod|
        assign_labels(pod, manifest)
        assign_labels(pod, cluster_manifest)
        assign_annotations(pod, manifest)
        assign_annotations(pod, cluster_manifest)
        pod.metadata.namespace = namespace
        if spec = pod.spec
          spec.restart_policy = manifest.restart_policy
          spec.volumes = generate_volumes
          spec.containers << generate_container
        end
      end
    end
  end
end
