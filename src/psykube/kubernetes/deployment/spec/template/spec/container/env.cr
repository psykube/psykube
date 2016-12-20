require "yaml"

class Psykube::Kubernetes::Deployment::Spec::Template::Spec::Container::Env
  YAML.mapping({
    name:       String,
    value:      String | Nil,
    value_from: {type: ValueFrom, nilable: true, key: "valueFrom"},
  }, true)

  def initialize(@name : String, @value : String)
  end

  def initialize(@name : String, @value_from : ValueFrom)
  end
end

require "./env/*"
