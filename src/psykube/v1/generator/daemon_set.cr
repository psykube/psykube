abstract class Psykube::V1::Generator
  class DaemonSet < Generator
    class InvalidHealthcheck < Exception; end

    include Concerns::PodHelper

    protected def result
      Pyrite::Api::Extensions::V1beta1::DaemonSet.new(
        metadata: generate_metadata,
        spec: Pyrite::Api::Extensions::V1beta1::DaemonSetSpec.new(
          template: generate_pod_template,
          selector: generate_selector,
          update_strategy: Pyrite::Api::Extensions::V1beta1::DaemonSetUpdateStrategy.new(
            type: "RollingUpdate",
            rolling_update: Pyrite::Api::Extensions::V1beta1::RollingUpdateDaemonSet.new(
              max_unavailable: manifest.max_unavailable
            )
          ),
        )
      )
    end
  end
end
