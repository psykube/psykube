require "../../../../concerns/mapping"

class Psykube::Kubernetes::Pod::Spec::Container::Env::ValueFrom::ResourceFieldRef
  Kubernetes.mapping({
    container_name: String | Nil,
    resource:       String,
    divisor:        String | Nil,
  })

  def initialize(@resource : String, @container_name : String? = nil, @divisor : String? = nil)
  end
end
