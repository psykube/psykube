require "../../name_cleaner"

class Psykube::V2::Manifest::DaemonSet < ::Psykube::V2::Manifest
  declare("DaemonSet", {
    ready_timeout: {type: Int32, optional: true},
    replicas:      {type: Int32, optional: true},
    recreate:      {type: Bool, optional: true},
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

require "./daemon_set/*"
