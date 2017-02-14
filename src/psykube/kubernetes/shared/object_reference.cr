require "../concerns/mapping"

class Psykube::Kubernetes::Shared::ObjectReference
  Kubernetes.mapping({
    api_version:      String?,
    field_path:       String?,
    kind:             String?,
    name:             String?,
    namespace:        String?,
    resource_version: String?,
    uid:              String?,
  })
end
