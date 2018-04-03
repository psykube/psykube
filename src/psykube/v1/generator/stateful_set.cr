require "./concerns/*"

class Psykube::V1::Generator::StatefulSet < ::Psykube::Generator
  include Concerns::PodHelper
  cast_manifest Manifest

  protected def result
    Pyrite::Api::Apps::V1beta1::StatefulSet.new(
      metadata: generate_metadata,
      spec: Pyrite::Api::Apps::V1beta1::StatefulSetSpec.new(
        selector: generate_selector,
        service_name: name,
        replicas: manifest.replicas,
        volume_claim_templates: generate_volume_claim_templates,
        template: generate_pod_template,
        update_strategy: Pyrite::Api::Apps::V1beta1::StatefulSetUpdateStrategy.new(
          type: "RollingUpdate",
          rolling_update: Pyrite::Api::Apps::V1beta1::RollingUpdateStatefulSetStrategy.new(
            partition: manifest.partition
          )
        ),
      )
    )
  end

  # Strategy
  private def generate_volume_claim_templates
    PersistentVolumeClaims.result(self)
  end
end
