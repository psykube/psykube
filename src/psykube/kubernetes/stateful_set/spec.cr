require "../concerns/mapping"
require "../persistent_volume_claim"
require "../pod_template/template"

class Psykube::Kubernetes::StatefulSet::Spec
  Kubernetes.mapping({
    pod_management_policy:  String?,
    revision_history_limit: UInt32?,
    replicas:               UInt32?,
    selector:               Shared::Selector,
    service_name:           String,
    template:               PodTemplate::Template,
    volume_claim_templates: Array(PersistentVolumeClaim)?,
    update_strategy:        UpdateStrategy?,
  })

  def initialize(name : String, @service_name : String)
    @selector = Shared::Selector.new(name)
    @template = PodTemplate::Template.new(name)
  end
end

require "./spec/*"
