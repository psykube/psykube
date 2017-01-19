require "../../../concerns/mapping"

class Psykube::Kubernetes::Pod::Spec::Container
  class Probe
    Kubernetes.mapping({
      exec:                  Action::Exec | Nil,
      http_get:              Action::HttpGet | Nil,
      tcp_socket:            Action::TcpSocket | Nil,
      initial_delay_seconds: UInt32?,
      timeout_seconds:       UInt32?,
      period_seconds:        UInt32?,
      success_threshold:     UInt32?,
      failure_threshold:     UInt32?,
    })

    def initialize
    end
  end
end

require "./action/*"
