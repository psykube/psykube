require "../kubernetes/deployment"
require "../kubernetes/pod"
require "./concerns/*"

class Psykube::Generator
  class StatefulSet < Generator
    class InvalidHealthcheck < Exception; end

    include Concerns::PodHelper

    protected def result
      Kubernetes::StatefulSet.new(manifest.name, manifest.name).tap do |deployment|
        deployment.metadata.namespace = namespace
        if spec = deployment.spec
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
