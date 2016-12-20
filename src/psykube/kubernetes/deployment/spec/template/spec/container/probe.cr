require "yaml"

class Psykube::Kubernetes::Deployment::Spec::Template::Spec::Container
  class Probe
    YAML.mapping({
      exec:                 Action::Exec | Nil,
      http_get:             {type: Action::HttpGet, nilable: true, key: "httpGet"},
      tcp_socket:           {type: Action::TcpSocket, nilable: true, key: "tcpSocket"},
      intial_delay_seconds: {type: UInt32, key: "initialDelaySeconds", nilable: true},
      timeout_seconds:      {type: UInt32, key: "timeoutSeconds", nilable: true},
      period_seconds:       {type: UInt32, key: "periodSeconds", nilable: true},
      success_threshold:    {type: UInt32, key: "successThreshold", nilable: true},
      failure_threshold:    {type: UInt32, key: "failureThreshold", nilable: true},
    }, true)

    def initialize
    end
  end
end

require "./action/*"
