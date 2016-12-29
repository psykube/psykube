require "../../concerns/mapping"

class Psykube::Kubernetes::Deployment::Spec
  Kubernetes.mapping(
    replicas: Int32 | Nil,
    selector: Shared::Selector,
    template: Template,
    strategy: Strategy | Nil,
    min_ready_seconds: UInt32 | Nil,
    revision_history_limit: UInt32 | Nil,
    paused: Bool | Nil,
    rollback_to: RollbackTo | Nil
  )

  def initialize(name : String)
    @selector = Shared::Selector.new(name)
    @template = Template.new(name)
  end
end

require "./spec/*"
require "../../shared/selector"
