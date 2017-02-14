require "../../concerns/mapping"
require "../../shared/selector"
require "../../pod_template/template"

class Psykube::Kubernetes::Job::Spec
  Kubernetes.mapping(
    activeDeadlineSeconds: Int64?,
    completions: Int64?,
    manualSelector: Bool?,
    parallelism: Int64?,
    selector: Shared::Selector,
    template: PodTemplate::Template
  )

  def initialize(name : String)
    @selector = Shared::Selector.new(name)
    @template = PodTemplate::Template.new(name)
  end
end
