class Psykube::V2::Manifest::Deployment < ::Psykube::V2::Manifest
  declare("Deployment", {
    min_ready_seconds: {type: Int32, optional: true},
    replicas:          {type: Int32, optional: true},
    rollout:           {type: Rollout, optional: true},
    autoscale:         {type: V1::Manifest::Autoscale, optional: true},
  })

  # Set as its our default
  @type = "Deployment"

  def rollout
    case @rollout
    when .nil?
      Rollout.new
    when true
      @rollout
    end
  end
end

require "./deployment/*"
