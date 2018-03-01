class Psykube::V1::Generator::Deployment < ::Psykube::Generator
  include Concerns::PodHelper
  cast_manifest Manifest

  protected def result
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
end
