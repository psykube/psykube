require "../../../concerns/mapping"

class Psykube::Kubernetes::Service::Spec::Port
  Kubernetes.mapping(
    name: String?,
    protocol: String,
    port: UInt16,
    target_port: UInt16?,
    node_port: {type: UInt16, nilable: true, clean: true}
  )

  def initialize(name : String, port_number : UInt16)
    @name = name
    @port = port_number
    @protocol = "TCP"
  end
end
