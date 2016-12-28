require "../../../concerns/mapping"

class Psykube::Kubernetes::Pod::Spec::Container
  class Lifecycle
    Kubernetes.mapping({
      post_start: Event | Nil,
      pre_stop:   Event | Nil,
    })
  end
end

require "./lifecycle/*"
