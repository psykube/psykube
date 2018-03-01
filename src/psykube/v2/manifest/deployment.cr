require "../../name_cleaner"

class Psykube::V2::Manifest::Deployment < ::Psykube::V2::Manifest
  declare("Deployment", {
    min_ready_seconds: {type: Int32, nilable: true},
    replicas:          {type: Int32, nilable: true},
    rollout:           {type: Rollout, nilable: true, getter: false},
    autoscale:         {type: V1::Manifest::Autoscale, nilable: true},
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
