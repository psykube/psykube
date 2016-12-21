require "yaml"

class Psykube::Kubernetes::Deployment::Spec::Template::Spec::Container::Env::ValueFrom::KeyRef
  YAML.mapping({
    name: String,
    key:  String,
  }, true)

  def initialize(@name : String, @key : String)
  end
end
