require "../../../concerns/mapping"

class Psykube::Kubernetes::Pod::Spec::Container::Port
  Kubernetes.mapping({
    name:           String?,
    container_port: UInt16,
    host_port:      UInt16?,
    protocol:       String?,
    host_ip:        {type: String, nilable: true, key: "hostIP"},
  })

  def initialize(@name : String, @container_port : UInt16)
  end
end
