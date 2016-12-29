require "../../concerns/mapping"

class Psykube::Kubernetes::Ingress::Spec::Backend
  Kubernetes.mapping(
    service_name: String,
    service_port: UInt16
  )

  def initialize(service_name : String, service_port : UInt16)
    @service_name = service_name
    @service_port = service_port
  end
end
