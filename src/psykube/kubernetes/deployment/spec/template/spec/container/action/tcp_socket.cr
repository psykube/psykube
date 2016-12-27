require "../../../../../concerns/mapping"

class Psykube::Kubernetes::Deployment::Spec::Template::Spec::Container::Action::TcpSocket
  Kubernetes.mapping({
    port: UInt16,
  })

  def initialize(@port : UInt16)
  end
end
