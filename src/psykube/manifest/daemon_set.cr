class Psykube::Manifest::DaemonSet < ::Psykube::Manifest
  declare("DaemonSet", {
    ready_timeout: {type: Int32, optional: true},
    replicas:      {type: Int32, optional: true},
    recreate:      {type: Bool, optional: true},
    rollout:       {type: Rollout, optional: true},
  }, jobable: true)

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
