require "../../../../../concerns/mapping"

class Psykube::Kubernetes::Deployment::Spec::Template::Spec::Volume::DownwardAPI::Item::ResourceFieldRef
  Kubernetes.mapping({
    container_name: String,
    resource:       String,
    divisor:        String,
  })
end
