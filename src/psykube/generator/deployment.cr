abstract class Psykube::Generator
  class Deployment < Generator
    class InvalidHealthcheck < Exception; end

    include Concerns::PodHelper

    protected def result(manifest : Manifest::V1)
      Pyrite::Api::Extensions::V1beta1::Deployment.new(
        metadata: generate_metadata,
        spec: Pyrite::Api::Extensions::V1beta1::DeploymentSpec.new(
          selector: generate_selector,
          replicas: manifest.replicas,
          revision_history_limit: manifest.revision_history_limit,
          progress_deadline_seconds: manifest.deploy_timeout,
          template: generate_pod_template,
          strategy: Pyrite::Api::Extensions::V1beta1::DeploymentStrategy.new(
            type: "RollingUpdate",
            rolling_update: Pyrite::Api::Extensions::V1beta1::RollingUpdateDeployment.new(
              max_unavailable: manifest.max_unavailable,
              max_surge: manifest.max_surge
            )
          ),
        )
      )
    end

    protected def result(manifest : Manifest::V2::Deployment)
      Pyrite::Api::Extensions::V1beta1::Deployment.new(
        metadata: generate_metadata,
        spec: Pyrite::Api::Extensions::V1beta1::DeploymentSpec.new(
          selector: generate_selector,
          replicas: manifest.replicas,
          revision_history_limit: manifest.deploy.history_limit,
          min_ready_seconds: manifest.min_ready_seconds,
          progress_deadline_seconds: manifest.rollout.progress_timeout,
          template: generate_pod_template,
          strategy: Pyrite::Api::Extensions::V1beta1::DeploymentStrategy.new(
            type: "RollingUpdate",
            rolling_update: Pyrite::Api::Extensions::V1beta1::RollingUpdateDeployment.new(
              max_unavailable: manifest.rollout.max_unavailable,
              max_surge: manifest.rollout.max_surge
            )
          ),
        )
      )
    end
  end
end
