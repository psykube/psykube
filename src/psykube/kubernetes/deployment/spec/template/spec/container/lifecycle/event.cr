require "yaml"

class Psykube::Kubernetes::Deployment::Spec::Template::Spec::Container
  class Lifecycle::Event
    YAML.mapping({
      exec:       Action::Exec | Nil,
      http_get:   {type: Action::HttpGet, nilable: true, key: "httpGet"},
      tcp_socket: {type: Action::TcpSocket, nilable: true, key: "tcpSocket"},
    }, true)
  end
end

require "../action/*"
