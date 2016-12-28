require "../../../../concerns/mapping"

class Psykube::Kubernetes::Pod::Spec::Container
  class Lifecycle::Event
    Kubernetes.mapping({
      exec:       Action::Exec | Nil,
      http_get:   Action::HttpGet | Nil,
      tcp_socket: Action::TcpSocket | Nil,
    })
  end
end

require "../action/*"
