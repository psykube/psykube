require "../../concerns/mapping"

class Psykube::Kubernetes::Deployment::Spec::Strategy
  Kubernetes.mapping({
    type:           String | Nil,
    rolling_update: {type: RollingUpdate, nilable: true, key: "rollingUpdate"},
  })
end

require "./strategy/*"
