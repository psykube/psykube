require "yaml"

class Psykube::Kubernetes::Service::Spec::Port
  YAML.mapping(
    name: {type: String},
    protocol: {type: String},
    port: {type: UInt16},
    targetPort: {type: UInt16, nilable: true},
    nodePort: {type: UInt16, nilable: true}
  )

  def initialize(name : String, port_number : UInt16)
    @name = name
    @port = port_number
    @protocol = "TCP"
  end
end
