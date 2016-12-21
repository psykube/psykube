require "yaml"

class Psykube::Kubernetes::Deployment::Spec::Template::Spec::Volume::DownwardAPI::Item
  YAML.mapping({
    path:               String,
    field_ref:          {type: FieldRef, key: "fieldRef "},
    resource_field_ref: {type: ResourceFieldRef, key: "resourceFieldRef"},
    mode:               {type: UInt16, nilable: true, key: "defaultMode"},
  }, true)
end

require "./item/*"
