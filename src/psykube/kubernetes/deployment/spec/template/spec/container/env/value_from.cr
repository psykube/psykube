require "yaml"

class Psykube::Kubernetes::Deployment::Spec::Template::Spec::Container::Env::ValueFrom
  YAML.mapping({
    field_ref:          {type: FieldRef, nilable: true, key: "fieldRef"},
    resource_field_ref: {type: ResourceFieldRef, nilable: true, key: "resourceFieldRef"},
    config_map_key_ref: {type: KeyRef, nilable: true, key: "configMapKeyRef"},
    secret_key_ref:     {type: KeyRef, nilable: true, key: "secretKeyRef"},
  }, true)

  def initialize
  end
end

require "./value_from/*"
