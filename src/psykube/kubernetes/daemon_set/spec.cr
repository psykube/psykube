require "../../concerns/mapping"
require "../../pod_template/template"

class Psykube::Kubernetes::DaemonSet::Spec
  Kubernetes.mapping(
    selector: Shared::Selector,
    template: PodTemplate::Template,
  )

  def initialize(name : String)
    @selector = Shared::Selector.new(name)
    @template = PodTemplate::Template.new(name)
  end
end

require "./spec/*"
require "../../shared/selector"
