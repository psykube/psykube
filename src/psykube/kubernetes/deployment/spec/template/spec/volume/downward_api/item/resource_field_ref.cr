require "yaml"

class Psykube::Kubernetes::Deployment::Spec::Template::Spec::Volume::DownwardAPI::Item::ResourceFieldRef
  YAML.mapping({
    container_name: {type: String, key: "containerName"},
    resource:       String,
    divisor:        String,
  }, true)
end
