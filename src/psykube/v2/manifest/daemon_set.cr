require "../../name_cleaner"

class Psykube::V2::Manifest::DaemonSet < ::Psykube::V2::Manifest
  declare("DaemonSet", {
    ready_timeout: {type: Int32, nilable: true},
    replicas:      {type: Int32, nilable: true},
    rollout:       {type: Rollout, nilable: true, getter: false},
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
