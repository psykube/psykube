require "../../../../concerns/mapping"

class Psykube::Kubernetes::Deployment::Spec::Template::Spec::ImagePullSecret
  Kubernetes.mapping({
    name: String,
  })

  def initialize(@name : String)
  end
end
