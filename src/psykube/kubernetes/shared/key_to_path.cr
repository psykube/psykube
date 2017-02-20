require "../concerns/mapping"

class Psykube::Kubernetes::Shared::KeyToPath
  Kubernetes.mapping({
    key:  String,
    path: String,
    mode: Int32?,
  })
end
