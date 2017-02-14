require "../concerns/mapping"

class Psykube::Kubernetes::Node::Spec
  Kubernetes.mapping({
    external_id:   {type: String, key: "externalID", nilable: true},
    pod_cidr:      {type: String, key: "podCIDR", nilable: true},
    provider_id:   {type: String, key: "providerID", nilable: true},
    unschedulable: Bool?,
  })
end
