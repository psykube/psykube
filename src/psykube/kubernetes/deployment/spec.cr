require "../../concerns/mapping"

class Psykube::Kubernetes::Deployment::Spec
  Kubernetes.mapping(
    replicas: Int32?,
    selector: Shared::Selector,
    template: Template,
    strategy: Strategy?,
    min_ready_seconds: UInt32?,
    revision_history_limit: UInt32?,
    paused: Bool?,
    rollback_to: RollbackTo?
  )

  def initialize(name : String)
    @selector = Shared::Selector.new(name)
    @template = Template.new(name)
  end
end

require "./spec/*"
require "../../shared/selector"
