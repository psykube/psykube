require "yaml"

class Psykube::Kubernetes::Deployment::Spec::Template::Spec::Container::Resources
  YAML.mapping({
    limits:   Hash(String, String),
    requests: Hash(String, String),
  }, true)

  def initialize(@limits : Hash(String, String), @requests : Hash(String, String))
  end
end
