require "../concerns/mapping"

class Psykube::Kubernetes::ThirdPartyResource::Version
  Kubernetes.mapping({
    name: String?,
  })
end
