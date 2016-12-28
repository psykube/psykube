require "../../../concerns/mapping"

class Psykube::Kubernetes::Service::Spec::Port
  Kubernetes.mapping(
    name: String,
    protocol: String,
    port: UInt16,
    targetPort: UInt16 | Nil,
    nodePort: UInt16 | Nil
  )

  def initialize(name : String, port_number : UInt16)
    @name = name
    @port = port_number
    @protocol = "TCP"
  end
end
