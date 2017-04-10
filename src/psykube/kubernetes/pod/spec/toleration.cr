require "../../concerns/mapping"

class Psykube::Kubernetes::Pod::Spec::Toleration
  Kubernetes.mapping({
    effect:             String,
    key:                String,
    operator:           String,
    value:              String?,
    toleration_seconds: Int32?,
  })
end
