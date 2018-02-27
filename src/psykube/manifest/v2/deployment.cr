require "yaml"
require "../../name_cleaner"

class Psykube::Manifest::V2::Deployment
  V2.declare_manifest("Deployment", {
    ready_timeout: Int32?,
    replicas:      Int32?,
    rollout:       {type: Rollout, nilable: true, getter: false},
    autoscale:     {type: V1::Autoscale, nilable: true},
  }, default: true)

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
