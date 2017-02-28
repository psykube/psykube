require "../kubernetes/deployment"
require "../kubernetes/pod"
require "./concerns/*"

class Psykube::Generator
  class Deployment < Generator
    class InvalidHealthcheck < Exception; end

    include Concerns::PodHelper

    protected def result
      Kubernetes::Deployment.new(manifest.name).tap do |deployment|
        deployment.metadata.namespace = namespace
        if spec = deployment.spec
          spec.template.spec.restart_policy = manifest.restart_policy
          spec.template.spec.volumes = generate_volumes
          spec.template.spec.containers << generate_container
          spec.strategy = generate_strategy
          spec.progress_deadline_seconds = manifest.deploy_timeout
        end
      end
    end

    # Strategy
    private def generate_strategy
      Kubernetes::Deployment::Spec::Strategy.new(
        max_unavailable: manifest.max_unavailable,
        max_surge: manifest.max_surge
      )
    end
  end
end
