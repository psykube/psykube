require "../../name_cleaner"

class Psykube::V2::Manifest::StatefulSet < ::Psykube::V2::Manifest
  declare("StatefulSet", {
    parallel:      {type: Bool, optional: true},
    service_name:  {type: String, optional: true},
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

  def service_name
    @service_name ||
      case (services = @services)
      when Array(String)
        services.first.downcase
      when Hash
        services.keys.first
      end
  end
end

require "./stateful_set/*"
