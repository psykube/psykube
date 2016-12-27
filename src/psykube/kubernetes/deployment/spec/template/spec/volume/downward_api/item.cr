require "../../../../../concerns/mapping"

class Psykube::Kubernetes::Deployment::Spec::Template::Spec::Volume::DownwardAPI::Item
  Kubernetes.mapping({
    path:               String,
    field_ref:          {type: FieldRef, key: "fieldRef "},
    resource_field_ref: {type: ResourceFieldRef, key: "resourceFieldRef"},
    mode:               {type: UInt16, nilable: true, key: "defaultMode"},
  })
end

require "./item/*"
