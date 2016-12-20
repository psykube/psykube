require "yaml"

class Psykube::Kubernetes::Deployment::Spec::Strategy::RollingUpdate
  YAML.mapping({
    max_unavailable: {type: String, nilable: true, key: "maxUnavailable"},
    max_surge:       {type: String, nilable: true, key: "maxSurge"},
  }, true)
end
