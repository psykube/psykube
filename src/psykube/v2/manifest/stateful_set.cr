require "../../name_cleaner"

class Psykube::V2::Manifest::StatefulSet < ::Psykube::V2::Manifest
  declare("StatefulSet", {
    parallel:      {type: Bool, optional: true},
    ready_timeout: {type: Int32, optional: true},
    replicas:      {type: Int32, optional: true},
    rollout:       {type: Rollout, optional: true},
  })

  def rollout
    case @rollout
    when .nil?
      Rollout.new
    when true
      @rollout
    end
  end
end

require "./stateful_set/*"
