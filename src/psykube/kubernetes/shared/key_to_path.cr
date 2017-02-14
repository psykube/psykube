require "../concerns/mapping"

class Psykube::Kubernetes::Shared::KeyToPath
  Kubernetes.mapping({
    key:   String,
    value: String,
    mode:  Int32?,
  })
end
