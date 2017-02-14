require "../concerns/mapping"

class Psykube::Kubernetes::Node::Status
  Kubernetes.mapping({
    addresses:        Array(Address)?,
    allocatable:      Hash(String, String)?,
    capacity:         Hash(String, String)?,
    conditions:       Array(Condition)?,
    deamon_endpoints: Array(DaemonEndpoint)?,
    images:           Array(Image)?,
    node_info:        NodeInfo?,
    phase:            String?,
    volumes_attached: Array(AttachedVolume)?,
    volumes_in_use:   Array(String)?,
  })
end

require "./status/*"
