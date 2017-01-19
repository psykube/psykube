require "../../../../concerns/mapping"

class Psykube::Kubernetes::Pod::Spec::Container
  class Lifecycle::Event
    Kubernetes.mapping({
      exec:       Action::Exec?,
      http_get:   Action::HttpGet?,
      tcp_socket: Action::TcpSocket?,
    })
  end
end

require "../action/*"
