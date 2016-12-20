require "yaml"

class Psykube::Kubernetes::Deployment::Spec::Template::Spec::ImagePullSecret
  YAML.mapping({
    name: String,
  }, true)

  def initialize(@name : String)
  end
end
