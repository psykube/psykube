require "../../../../../concerns/mapping"

class Psykube::Kubernetes::Deployment::Spec::Template::Spec::Volume::DownwardAPI::Item
  Kubernetes.mapping({
    path:               String,
    field_ref:          FieldRef,
    resource_field_ref: ResourceFieldRef,
    default_mode:       UInt16 | Nil,
  })
end

require "./item/*"
