require "../../../../concerns/mapping"

class Psykube::Kubernetes::Shared::VolumeSource::DownwardAPI::Item
  Kubernetes.mapping({
    path:               String,
    field_ref:          FieldRef?,
    resource_field_ref: ResourceFieldRef?,
    mode:               Int32?,
  })
end

require "./item/*"
