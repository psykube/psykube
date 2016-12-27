require "../../../../../concerns/mapping"

class Psykube::Kubernetes::Deployment::Spec::Template::Spec::Container::Action::Exec
  Kubernetes.mapping({
    command: Array(String),
  })

  def initialize(command : String)
    initialize command.split(" ")
  end

  def initialize(@command : Array(String))
  end
end
