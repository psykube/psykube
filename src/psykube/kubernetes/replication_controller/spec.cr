require "../../concerns/mapping"
require "../../pod_template/template"

class Psykube::Kubernetes::ReplicationController::Spec
  Kubernetes.mapping(
    replicas: UInt32?,
    selector: Shared::Selector,
    template: PodTemplate::Template,
    min_ready_seconds: UInt32?,
  )

  def initialize(name : String)
    @selector = Shared::Selector.new(name)
    @template = PodTemplate::Template.new(name)
  end
end

require "./spec/*"
require "../../shared/selector"
