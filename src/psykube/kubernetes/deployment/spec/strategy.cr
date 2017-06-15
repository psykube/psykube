require "../../concerns/mapping"

class Psykube::Kubernetes::Deployment::Spec::Strategy
  Kubernetes.mapping({
    type:           String?,
    rolling_update: RollingUpdate?,
  })

  def initialize(max_unavailable : UInt32 | String, max_surge : UInt32 | String)
    @type = "RollingUpdate"
    @rolling_update = RollingUpdate.new(
      max_unavailable: max_unavailable,
      max_surge: max_surge
    )
  end
end

require "./strategy/*"
