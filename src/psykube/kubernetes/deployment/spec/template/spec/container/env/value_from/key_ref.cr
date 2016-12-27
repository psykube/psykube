require "../../../../../concerns/mapping"

class Psykube::Kubernetes::Deployment::Spec::Template::Spec::Container::Env::ValueFrom::KeyRef
  Kubernetes.mapping({
    name: String,
    key:  String,
  })

  def initialize(@name : String, @key : String)
  end
end
