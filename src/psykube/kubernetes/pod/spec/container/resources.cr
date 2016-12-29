require "../../../concerns/mapping"

class Psykube::Kubernetes::Pod::Spec::Container::Resources
  Kubernetes.mapping({
    limits:   Hash(String, String) | Nil,
    requests: Hash(String, String) | Nil,
  })

  def initialize(@limits : Hash(String, String), @requests : Hash(String, String))
  end
end
