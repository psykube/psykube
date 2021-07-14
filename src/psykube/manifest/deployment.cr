class Psykube::Manifest::Deployment < ::Psykube::Manifest
  declare("Deployment", {
    min_ready_seconds: {type: Int32, optional: true},
    replicas:          {type: Int32, optional: true},
    recreate:          {type: Bool, optional: true},
    rollout:           {type: Rollout, optional: true},
    autoscale:         {type: Manifest::Autoscale, optional: true},
  }, jobable: true)

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
