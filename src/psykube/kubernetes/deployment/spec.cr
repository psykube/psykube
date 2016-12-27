require "../../concerns/mapping"

class Psykube::Kubernetes::Deployment::Spec
  Kubernetes.mapping(
    replicas: Int32 | Nil,
    selector: Shared::Selector,
    template: Template,
    strategy: Strategy | Nil,
    min_ready_seconds: {type: Int32, nilable: true, key: "minReadySeconds"},
    revision_history_limit: {type: Int32, nilable: true, key: "revisionHistoryLimit"},
    paused: Bool | Nil,
    rollback_to: {type: RollbackTo, key: "rollbackTo", nilable: true}
  )

  def initialize(name : String)
    @selector = Shared::Selector.new(name)
    @template = Template.new(name)
  end
end

require "./spec/*"
require "../../shared/selector"
