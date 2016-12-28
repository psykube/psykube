require "../../../../../concerns/mapping"

class Psykube::Kubernetes::Deployment::Spec::Template::Spec::Container::Env::ValueFrom::ResourceFieldRef
  Kubernetes.mapping({
    container_name: String,
    resource:       String,
    divisor:        String,
  })
end
