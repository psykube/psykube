require "yaml"

class Psykube::Kubernetes::Deployment::Spec::Template::Spec::Container::Action::TcpSocket
  YAML.mapping({
    port: UInt16,
  }, true)

  def initialize(@port : UInt16)
  end
end
