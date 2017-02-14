require "../../concerns/mapping"
require "../../pod_template/template"

class Psykube::Kubernetes::Deployment::Spec
  Kubernetes.mapping(
    replicas: Int32?,
    selector: Shared::Selector,
    template: PodTemplate::Template,
    strategy: Strategy?,
    min_ready_seconds: UInt32?,
    progress_deadline_seconds: UInt32?,
    revision_history_limit: UInt32?,
    paused: Bool?,
    rollback_to: RollbackTo?
  )

  def initialize(name : String)
    @selector = Shared::Selector.new(name)
    @template = PodTemplate::Template.new(name)
  end
end

require "./spec/*"
require "../../shared/selector"
