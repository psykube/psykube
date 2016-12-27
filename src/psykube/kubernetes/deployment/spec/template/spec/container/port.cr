require "../../../../../concerns/mapping"

class Psykube::Kubernetes::Deployment::Spec::Template::Spec::Container::Port
  Kubernetes.mapping({
    name:           String,
    container_port: {type: UInt16, key: "containerPort"},
    host_port:      {type: UInt16, nilable: true, key: "hostPort"},
    protocol:       String | Nil,
    host_ip:        {type: String, nilable: true, key: "hostIP"},
  })

  def initialize(@name : String, @container_port : UInt16)
  end
end
