require "../../../../concerns/mapping"

class Psykube::Kubernetes::Deployment::Spec::Template::Spec::Container
  class Probe
    Kubernetes.mapping({
      exec:                 Action::Exec | Nil,
      http_get:             Action::HttpGet | Nil,
      tcp_socket:           Action::TcpSocket | Nil,
      intial_delay_seconds: UInt32 | Nil,
      timeout_seconds:      UInt32 | Nil,
      period_seconds:       UInt32 | Nil,
      success_threshold:    UInt32 | Nil,
      failure_threshold:    UInt32 | Nil,
    })

    def initialize
    end
  end
end

require "./action/*"
