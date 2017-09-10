require "./concerns/*"

abstract class Psykube::Generator
  class StatefulSet < Generator
    class InvalidHealthcheck < Exception; end

    include Concerns::PodHelper

    protected def result
      Kubernetes::Apis::Apps::V1beta1::StatefulSet.new(
        metadata: generate_metadata,
        spec: Kubernetes::Apis::Apps::V1beta1::StatefulSetSpec.new(
          selector: generate_selector,
          service_name: name,
          replicas: manifest.replicas,
          volume_claim_templates: generate_volume_claim_templates,
          template: generate_pod_template,
          update_strategy: Kubernetes::Apis::Apps::V1beta1::StatefulSetUpdateStrategy.new(
            type: "RollingUpdate",
            rolling_update: Kubernetes::Apis::Apps::V1beta1::RollingUpdateStatefulSetStrategy.new(
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
end
