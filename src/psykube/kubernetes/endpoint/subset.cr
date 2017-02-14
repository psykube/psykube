require "../concerns/mapping"

class Psykube::Kubernetes::Endpoint::Subset
  Kubernetes.mapping({
    addresses:           Array(Address)?,
    not_ready_addresses: Array(Address)?,
    ports:               Array(Port)?,
  })
end

require "./subset/*"
