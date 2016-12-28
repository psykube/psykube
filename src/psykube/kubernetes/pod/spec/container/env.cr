require "../../../concerns/mapping"

class Psykube::Kubernetes::Pod::Spec::Container::Env
  Kubernetes.mapping({
    name:       String,
    value:      String | Nil,
    value_from: ValueFrom | Nil,
  })

  def initialize(@name : String, @value : String)
  end

  def initialize(@name : String, @value_from : ValueFrom)
  end
end

require "./env/*"
