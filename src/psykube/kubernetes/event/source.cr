require "../concerns/mapping"

class Psykube::Kubernetes::Event::Source
  Kubernetes.mapping({
    component: String?,
    host:      String?,
  })
end
