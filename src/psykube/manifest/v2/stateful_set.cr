require "yaml"
require "../../name_cleaner"

class Psykube::Manifest::V2::StatefulSet
  V2.declare_manifest("StatefulSet", {
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
