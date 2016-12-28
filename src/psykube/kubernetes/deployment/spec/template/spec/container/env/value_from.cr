require "../../../../../concerns/mapping"

class Psykube::Kubernetes::Deployment::Spec::Template::Spec::Container::Env::ValueFrom
  Kubernetes.mapping({
    field_ref:          FieldRef | Nil,
    resource_field_ref: ResourceFieldRef | Nil,
    config_map_key_ref: KeyRef | Nil,
    secret_key_ref:     KeyRef | Nil,
  })

  def initialize
  end
end

require "./value_from/*"
