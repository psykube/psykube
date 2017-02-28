require "../../concerns/mapping"
require "../../shared/selector"
require "../../pod_template/template"

class Psykube::Kubernetes::ReplicaSet::Spec
  Kubernetes.mapping({
    min_ready_seconds: UInt32?,
    replicas:          UInt32?,
    selector:          Shared::Selector?,
    template:          PodTemplate::Template,
  })

  def initialize(name : String)
    @selector = Shared::Selector.new(name)
    @template = PodTemplate::Template.new(name)
  end
end
