require "../../../../../concerns/mapping"

class Psykube::Kubernetes::Deployment::Spec::Template::Spec::Container
  class Lifecycle
    Kubernetes.mapping({
      post_start: {type: Event, nilable: true, key: "postStart"},
      pre_stop:   {type: Event, nilable: true, key: "preStop"},
    })
  end
end

require "./lifecycle/*"
