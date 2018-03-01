require "../../name_cleaner"

class Psykube::V2::Manifest::StatefulSet < ::Psykube::V2::Manifest
  declare("StatefulSet", {
    parallel:      {type: Bool, nilable: true},
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

require "./stateful_set/*"
