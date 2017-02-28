require "../../concerns/mapping"
require "../../shared/selector"
require "../../pod_template/template"

class Psykube::Kubernetes::Job::Spec
  Kubernetes.mapping(
    activeDeadlineSeconds: UInt32?,
    completions: UInt32?,
    manualSelector: Bool?,
    parallelism: UInt32?,
    selector: Shared::Selector,
    template: PodTemplate::Template
  )

  def initialize(name : String)
    @selector = Shared::Selector.new(name)
    @template = PodTemplate::Template.new(name)
  end
end
