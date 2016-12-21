require "yaml"

class Psykube::Kubernetes::Deployment::Spec::Template::Spec::Volume::ConfigMap::Item
  YAML.mapping({
    key:  String,
    path: String,
    mode: UInt16,
  }, true)
end
