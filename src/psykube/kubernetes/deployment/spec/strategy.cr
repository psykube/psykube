require "yaml"

class Psykube::Kubernetes::Deployment::Spec::Strategy
  YAML.mapping({
    type:           String | Nil,
    rolling_update: {type: RollingUpdate, nilable: true, key: "rollingUpdate"},
  }, true)
end

require "./strategy/*"
