require "../../../../../concerns/mapping"

class Psykube::Kubernetes::Deployment::Spec::Template::Spec::Container::Env
  Kubernetes.mapping({
    name:       String,
    value:      String | Nil,
    value_from: {type: ValueFrom, nilable: true, key: "valueFrom"},
  })

  def initialize(@name : String, @value : String)
  end

  def initialize(@name : String, @value_from : ValueFrom)
  end
end

require "./env/*"
