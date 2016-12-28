require "../../../../concerns/mapping"

class Psykube::Kubernetes::Pod::Spec::Container::Env::ValueFrom::KeyRef
  Kubernetes.mapping({
    name: String,
    key:  String,
  })

  def initialize(@name : String, @key : String)
  end
end
