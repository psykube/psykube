module Psykube::V2::Generator::Concerns::ProbeHelper
  class InvalidProbe < Exception; end

  extend self

  # Healthchecks
  def generate_container_liveness_probe(container : Manifest::Shared::Container, opt)
    generate_container_probe(container, opt)
  end

  def generate_container_readiness_probe(container : Manifest::Shared::Container, healthcheck : V1::Manifest::Healthcheck)
    generate_container_probe(container, healthcheck) if healthcheck.readiness
  end

  def generate_container_readiness_probe(container : Manifest::Shared::Container, opt)
    generate_container_probe(container, opt)
  end

  private def generate_container_probe(container : Manifest::Shared::Container, null : Nil)
  end

  private def generate_container_probe(container : Manifest::Shared::Container, enabled : Bool)
    return unless enabled && container.ports?
    Pyrite::Api::Core::V1::Probe.new(
      http_get: Pyrite::Api::Core::V1::HTTPGetAction.new(
        port: container.lookup_port "default"
      )
    )
  end

  private def generate_container_probe(container : Manifest::Shared::Container, healthcheck : V1::Manifest::Healthcheck | V1::Manifest::Readycheck)
    return unless healthcheck.http || healthcheck.tcp || healthcheck.exec
    raise InvalidProbe.new("Cannot perform http check without specifying ports.") if !container.ports? && healthcheck.http
    raise InvalidProbe.new("Cannot perform tcp check without specifying ports.") if !container.ports? && healthcheck.tcp
    Pyrite::Api::Core::V1::Probe.new(
      http_get: generate_container_probe_http_get(container, healthcheck.http),
      exec: generate_container_probe_exec(container, healthcheck.exec),
      tcp_socket: generate_container_probe_tcp_socket(container, healthcheck.tcp),
      initial_delay_seconds: healthcheck.initial_delay_seconds,
      timeout_seconds: healthcheck.timeout_seconds,
      period_seconds: healthcheck.period_seconds,
      success_threshold: healthcheck.success_threshold,
      failure_threshold: healthcheck.failure_threshold
    )
  end

  private def generate_container_probe_http_get(container : Manifest::Shared::Container, http : Nil)
  end

  private def generate_container_probe_http_get(container : Manifest::Shared::Container, enabled : Bool)
    Pyrite::Api::Core::V1::HTTPGetAction.new(
      port: container.lookup_port("default")
    ) if enabled
  end

  private def generate_container_probe_http_get(container : Manifest::Shared::Container, path : String)
    Pyrite::Api::Core::V1::HTTPGetAction.new(
      port: container.lookup_port("default"),
      path: path
    )
  end

  private def generate_container_probe_http_get(container : Manifest::Shared::Container, http_check : V1::Manifest::Healthcheck::Http)
    Pyrite::Api::Core::V1::HTTPGetAction.new(
      path: http_check.path,
      port: container.lookup_port(http_check.port).not_nil!,
      host: http_check.host,
      scheme: http_check.scheme,
      http_headers: http_check.headers.try(&.map { |k, v| Pyrite::Api::Core::V1::HTTPHeader.new(name: k, value: v) })
    )
  end

  private def generate_container_probe_tcp_socket(container : Manifest::Shared::Container, tcp : Nil)
  end

  private def generate_container_probe_tcp_socket(container : Manifest::Shared::Container, enabled : Bool)
    Pyrite::Api::Core::V1::TCPSocketAction.new(
      port: container.lookup_port "default"
    )
  end

  private def generate_container_probe_tcp_socket(container : Manifest::Shared::Container, port : String | Int32)
    Pyrite::Api::Core::V1::TCPSocketAction.new(
      port: container.lookup_port port
    )
  end

  private def generate_container_probe_tcp_socket(container : Manifest::Shared::Container, tcp : V1::Manifest::Healthcheck::Tcp)
    Pyrite::Api::Core::V1::TCPSocketAction.new(
      port: container.lookup_port tcp.port
    )
  end

  private def generate_container_probe_exec(container : Manifest::Shared::Container, exec : Nil)
  end

  private def generate_container_probe_exec(container : Manifest::Shared::Container, command : String)
    generate_container_probe_exec container, [command]
  end

  private def generate_container_probe_exec(container : Manifest::Shared::Container, exec : V1::Manifest::Healthcheck::Exec)
    generate_container_probe_exec container, exec.command
  end

  private def generate_container_probe_exec(container : Manifest::Shared::Container, command : Array(String))
    Pyrite::Api::Core::V1::ExecAction.new command: command
  end
end
