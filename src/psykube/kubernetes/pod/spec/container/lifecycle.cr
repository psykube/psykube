require "../../../concerns/mapping"

class Psykube::Kubernetes::Pod::Spec::Container
  class Lifecycle
    Kubernetes.mapping({
      post_start: Event?,
      pre_stop:   Event?,
    })
  end
end

require "./lifecycle/*"
