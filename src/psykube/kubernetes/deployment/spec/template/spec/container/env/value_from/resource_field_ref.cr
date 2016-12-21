require "yaml"

class Psykube::Kubernetes::Deployment::Spec::Template::Spec::Container::Env::ValueFrom::ResourceFieldRef
  YAML.mapping({
    container_name: {type: String, key: "containerName"},
    resource:       String,
    divisor:        String,
  }, true)
end
