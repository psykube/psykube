require "../../../../concerns/mapping"

class Psykube::Kubernetes::Pod::Spec::Container::Env::ValueFrom
  Kubernetes.mapping({
    field_ref:          FieldRef?,
    resource_field_ref: ResourceFieldRef?,
    config_map_key_ref: KeyRef?,
    secret_key_ref:     KeyRef?,
  })

  def initialize
  end
end

require "./value_from/*"
