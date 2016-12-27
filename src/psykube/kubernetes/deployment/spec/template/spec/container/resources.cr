require "../../../../../concerns/mapping"

class Psykube::Kubernetes::Deployment::Spec::Template::Spec::Container::Resources
  Kubernetes.mapping({
    limits:   Hash(String, String),
    requests: Hash(String, String),
  })

  def initialize(@limits : Hash(String, String), @requests : Hash(String, String))
  end
end
