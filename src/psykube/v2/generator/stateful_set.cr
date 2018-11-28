class Psykube::V2::Generator::StatefulSet < ::Psykube::Generator
  include Concerns::PodHelper
  cast_manifest Manifest::StatefulSet

  protected def result
    Pyrite::Api::Apps::V1beta1::StatefulSet.new(
      metadata: generate_metadata,
      spec: Pyrite::Api::Apps::V1beta1::StatefulSetSpec.new(
        selector: generate_selector,
        service_name: manifest.service_name || name,
        replicas: cluster.replicas || manifest.replicas,
        volume_claim_templates: generate_volume_claim_templates,
        template: generate_pod_template,
        update_strategy: generate_strategy,
        pod_management_policy: manifest.parallel ? "Parallel" : "OrderedReady"
      )
    )
  end

  # Strategy
  private def generate_strategy
    Pyrite::Api::Apps::V1beta1::StatefulSetUpdateStrategy.new(type: "Recreate") if manifest.recreate
    Pyrite::Api::Apps::V1beta1::StatefulSetUpdateStrategy.new(
      type: "RollingUpdate",
      rolling_update: Pyrite::Api::Apps::V1beta1::RollingUpdateStatefulSetStrategy.new(
        partition: manifest.@rollout.try(&.partition)
      )
    )
  end

  private def generate_volume_claim_templates
    PersistentVolumeClaims.result(self)
  end
end
