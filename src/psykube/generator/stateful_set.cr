require "../kubernetes/deployment"
require "../kubernetes/pod"
require "./concerns/*"

abstract class Psykube::Generator
  class StatefulSet < Generator
    class InvalidHealthcheck < Exception; end

    include Concerns::PodHelper

    protected def result
      Kubernetes::StatefulSet.new(name, name).tap do |stateful_set|
        assign_labels(stateful_set, manifest)
        assign_labels(stateful_set, cluster_manifest)
        assign_annotations(stateful_set, manifest)
        assign_annotations(stateful_set, cluster_manifest)
        stateful_set.metadata.namespace = namespace
        if spec = stateful_set.spec
          spec.replicas = manifest.replicas
          spec.template.spec.restart_policy = manifest.restart_policy
          spec.template.spec.volumes = generate_volumes
          spec.template.spec.containers << generate_container
          spec.volume_claim_templates = generate_volume_claim_templates
        end
      end
    end

    # Strategy
    private def generate_volume_claim_templates
      PersistentVolumeClaims.result(self)
    end
  end
end
