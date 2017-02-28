require "./concerns/resource"

class Psykube::Kubernetes::Job
  include Resource
  definition("batch/v1", "Job", {
    spec:   Spec?,
    status: {type: Status, nilable: true, clean: true},
  })

  def clean!
    if labels = spec.try(&.template.metadata.labels)
      labels.delete("controller-uid")
    end
    if match_labels = spec.try(&.selector.match_labels)
      match_labels.delete("controller-uid")
    end
    super
  end

  def initialize(name : String)
    previous_def
    @spec = Spec.new(name)
  end
end

require "./job/*"
