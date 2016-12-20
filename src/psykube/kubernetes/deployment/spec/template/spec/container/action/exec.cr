require "yaml"

class Psykube::Kubernetes::Deployment::Spec::Template::Spec::Container::Action::Exec
  YAML.mapping({
    command: Array(String),
  }, true)

  def initialize(command : String)
    initialize command.split(" ")
  end

  def initialize(@command : Array(String))
  end
end
