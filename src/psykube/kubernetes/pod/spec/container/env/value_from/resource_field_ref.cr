require "../../../../concerns/mapping"

class Psykube::Kubernetes::Pod::Spec::Container::Env::ValueFrom::ResourceFieldRef
  Kubernetes.mapping({
    container_name: String,
    resource:       String,
    divisor:        String,
  })
end
