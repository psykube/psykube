require "yaml"
require "../../name_cleaner"

class Psykube::V2::Manifest::StatefulSet < Manifest
  declare("StatefulSet", {
    parallel:      Bool?,
    ready_timeout: Int32?,
    replicas:      Int32?,
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
