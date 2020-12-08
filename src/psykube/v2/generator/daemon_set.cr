class Psykube::V2::Generator::DaemonSet < ::Psykube::Generator
  include Concerns::PodHelper
  cast_manifest Manifest::DaemonSet

  protected def result
    Pyrite::Api::Apps::V1::DaemonSet.new(
      metadata: generate_metadata,
      spec: Pyrite::Api::Apps::V1::DaemonSetSpec.new(
        template: generate_pod_template,
        selector: generate_selector,
        update_strategy: generate_strategy
      )
    )
  end

  private def generate_strategy
    return Pyrite::Api::Apps::V1::DaemonSetUpdateStrategy.new(type: "Recreate") if manifest.recreate
    Pyrite::Api::Apps::V1::DaemonSetUpdateStrategy.new(
      type: "RollingUpdate",
      rolling_update: Pyrite::Api::Apps::V1::RollingUpdateDaemonSet.new(
        max_unavailable: manifest.@rollout.try(&.max_unavailable)
      )
    )
  end
end
